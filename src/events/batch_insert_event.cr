class BatchInsertEvent < Pulsar::Event
  @@buffer = [] of PessoaTuple

  def initialize(@pessoa : PessoaTuple)
  end

  def pessoa
    @pessoa
  end

  def push(pessoa : PessoaTuple)
    @@buffer.push pessoa
  end

  def pop : PessoaTuple
    @@buffer.pop
  end

  def bulk_pop(batch_size = 10)
    tmp_buffer = [] of SavePessoa
    counter = 10
    while counter > 0 && !@@buffer.empty?
      operation = SavePessoa.from_tuple(pop)
      if operation.valid?
        tmp_buffer.push(operation)
      end
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
  event.push(event.pessoa)
  if event.count >= Application.settings.batch_insert_size
    AppDatabase.transaction do
      SavePessoa.import(event.bulk_pop)
    end
  end
end
