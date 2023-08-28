require "../spec_helper"

describe SavePessoa do
  it "should create new pessoa" do
    SavePessoa.create(apelido: "ana", nome: "Ana Barbosa",
      nascimento_as_string: "2000-01-01",
      stack_as_string: "[\"php\", \"python\"]") do |op, pessoa|
      pessoa.should_not be_nil
      pessoa.try &.stack_as_array.should eq ["php", "python"]
    end
  end
end
