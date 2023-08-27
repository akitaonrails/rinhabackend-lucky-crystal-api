class PessoaFactory < Avram::Factory
  def initialize
    apelido "zezinho"
    nome "José Roberto"
    nascimento Time.local
    stack "ruby, javascript, php"
  end
end
