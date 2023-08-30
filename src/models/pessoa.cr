class Pessoa < BaseModel
  table do
    column apelido : String
    column nome : String
    column nascimento : Time?
    column stack : String?
  end

  def nascimento_as_string=(value : String?)
    return unless value
    self.nascimento = Time.parse(value, "%Y-%m-%d", Time::Location.local)
  end

  def nascimento_as_string
    self.nascimento.format("%Y-%m-%d")
  end

  def stack_as_array : Array(String)
    begin
      Array(String).from_json(self.stack || "[]")
    rescue
      [] of String
    end
  end

  def self.from_params(params)
    pessoa = Pessoa.new id: UUID.random,
      apelido: params.get("apelido"),
      nome: params.get("nome"),
      nascimento: nil,
      stack: params.get("stack")

    pessoa.nascimento_as_string = params.get("nascimento")
    pessoa
  end

  def to_tuple : PessoaTuple
    PessoaTuple.new(id: id,
      apelido: apelido,
      nome: nome,
      nascimento: nascimento,
      stack: stack)
  end
end
