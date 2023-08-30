require "deque"

class BatchInsertEvent < Pulsar::Event
  @@buffer = Deque(SavePessoa).new(0)

  def initialize(@operation : SavePessoa?)
  end

  def operation
    @operation
  end

  def push(operation : SavePessoa?)
    return unless operation
    @@buffer.push operation
  end

  def shift : SavePessoa
    @@buffer.shift
  end

  def bulk_pop(batch_size = 10)
    tmp_buffer = [] of SavePessoa
    counter = 10
    while counter > 0 && !@@buffer.empty?
      tmp_buffer.push(shift)
      counter -= 1
    end
    tmp_buffer
  end

  def get_buffer
    @@buffer
  end

  def count : Int32
    @@buffer.size
  end
end

BatchInsertEvent.subscribe do |event|
  event.push(event.operation)
  if event.count >= Application.settings.batch_insert_size
    bulk = event.bulk_pop
    begin
      SavePessoa.import(bulk)
    rescue e
      Lucky::Log.error(exception: e) { "error bulk saving" }
    end
  end
end
