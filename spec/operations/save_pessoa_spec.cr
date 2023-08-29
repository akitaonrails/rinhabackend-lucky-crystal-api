require "../spec_helper"

describe SavePessoa do
  it "should create new pessoa" do
    SavePessoa.create(apelido: "ana", nome: "Ana Barbosa",
      nascimento: Time.utc,
      stack: "[\"php\", \"python\"]") do |op, pessoa|
      pessoa.should_not be_nil
      pessoa.try &.stack_as_array.should eq ["php", "python"]
    end
  end
end
