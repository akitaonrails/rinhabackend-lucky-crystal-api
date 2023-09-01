class SavePessoa < Pessoa::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns
  #
  permit_columns id, apelido, nome, nascimento, stack

  attribute nascimento_as_string : String
  attribute stack_as_string : String

  before_save do
    validate_required apelido
    validate_required nome

    validate_size_of apelido, max: 32
    validate_size_of nome, max: 100
  end

  def self.build(pessoa : Pessoa)
    new(id: pessoa.id,
      apelido: pessoa.apelido,
      nome: pessoa.nome,
      nascimento: pessoa.nascimento,
      stack: pessoa.stack)
  end

  def values : Hash(Symbol, String?)
    attributes_to_hash(column_attributes)
  end
end
