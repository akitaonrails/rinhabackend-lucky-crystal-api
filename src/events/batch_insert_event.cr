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
    tmp_buffer = [] of SavePessoa
    Application.settings.batch_insert_size.times do
      break if @@buffer.empty?
      tmp_buffer.push(shift)
    end
    tmp_buffer
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

BatchInsertEvent.subscribe do |event|
  event.push(event.operation)
  if event.operation.nil? || (event.count >= Application.settings.batch_insert_size)
    batch = event.get_batch
    SavePessoa.import(batch)
  end
end
