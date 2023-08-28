class Pessoa < BaseModel
  table do
    column apelido : String
    column nome : String
    column nascimento : Time
    column stack : String

    column searchable : String?
  end

  def stack_as_array : Array(String)
    self.stack.split(",")
  end
end
