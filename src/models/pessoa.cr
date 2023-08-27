class Pessoa < BaseModel
  table do
    column apelido : String
    column nome : String
    column nascimento : Time
    column stack : String
  end
end
