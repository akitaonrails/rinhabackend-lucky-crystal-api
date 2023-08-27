class SavePessoa < Pessoa::SaveOperation
  # To save user provided params to the database, you must permit them
  # https://luckyframework.org/guides/database/saving-records#perma-permitting-columns
  #
  permit_columns id, apelido, nome, nascimento, stack

  before_save do
    validate_required apelido
    validate_required nome
    validate_size_of apelido, max: 32
    validate_size_of nome, max: 100
  end
end
