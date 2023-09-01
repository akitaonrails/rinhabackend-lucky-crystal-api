require "deque"

class BatchInsertEvent < Pulsar::Event
  @@buffer = Deque(SavePessoa).new(0)
  getter :operation

  def initialize(@operation : SavePessoa?)
  end

  def push(operation : SavePessoa?)
    return unless operation
    @@buffer.push(operation.as(SavePessoa))
  end

  def shift : SavePessoa
    @@buffer.shift
  end

  def get_batch
    batch_size = Application.settings.batch_insert_size
    Array(SavePessoa).new(batch_size).tap do |tmp_buffer|
      batch_size.times do
        break if @@buffer.empty?
        tmp_buffer.push(shift)
      end
    end
  end

  def get_buffer
    @@buffer
  end

  def count : Int32
    @@buffer.size
  end

  def self.empty?
    @@buffer.empty?
  end

  def self.flush!
    while !self.empty?
      self.publish(nil)
    end
  end

end

class BulkInsert
  alias Params = Array(Hash(Symbol, String)) | Array(Hash(Symbol, String?)) | Array(Hash(Symbol, Nil))

  def initialize(@table : Avram::TableName, @params : Params, @column_names : Array(Symbol) = [] of Symbol)
  end

  def statement
    "insert into #{@table}(#{fields}) values #{values_sql_fragment} on conflict do nothing"
  end

  def args
    @params.flat_map(&.values)
  end

  private def fields
    @params.first.keys.join(", ")
  end

  private def values_sql_fragment
    @params.map_with_index { |params, offset| values_placeholders(params, offset * params.size) }.join(", ")
  end

  private def values_placeholders(params, offset = 0)
    String.build do |io|
      io << "("
      io << params.values.map_with_index { |_v, index| "$#{offset + index + 1}" }.join(", ")
      io << ")"
    end
  end

  def self.execute(operations)
    insert_values = operations.select(&.valid?).map(&.values)
    insert_sql = BulkInsert.new(Pessoa.table_name, insert_values, Pessoa.column_names)

    AppDatabase.transaction do
      AppDatabase.query insert_sql.statement, args: insert_sql.args do |_|
        begin
        rescue
        end
      end

      true
    end
  end
end

BatchInsertEvent.subscribe do |event|
  event.push(event.operation)

  if event.operation.nil? || (event.count >= Application.settings.batch_insert_size)
    batch = event.get_batch # this can't be in a fiber, or we'll have out of order items
    spawn { BulkInsert.execute(batch) }
  end
end
