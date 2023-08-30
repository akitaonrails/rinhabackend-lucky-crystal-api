alias PessoaTuple = NamedTuple(
  id: UUID,
  apelido: String,
  nome: String,
  nascimento: Time?,
  stack: String?)

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

  def self.from_hash(hash)
    pessoa = Pessoa.new id: hash[:id],
      apelido: hash[:apelido],
      nome: hash[:nome],
      nascimento: nil,
      stack: hash[:stack]

    pessoa.nascimento_as_string = hash[:nascimento]
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
