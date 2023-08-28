require "../spec_helper"

describe SavePessoa do
  it "should create new pessoa" do
    SavePessoa.create(apelido: "ana", nome: "Ana Barbosa", nascimento_as_string: "2000-01-01", stack: "ruby, php") do |op, pessoa|
      pessoa.should_not be_nil
    end
  end
end
