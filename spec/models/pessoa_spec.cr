require "../spec_helper"

describe SavePessoa do
  describe "should cast values" do
    pessoa = Pessoa.from_hash({id: UUID.random, apelido: "foo", nome: "bar", nascimento: nil, stack: nil})
    pessoa.apelido.should eq "foo"

    pessoa.nascimento_as_string = "2001-02-01"
    pessoa.nascimento.should eq Time.local(2001, 2, 1)

    pessoa.stack = "[\"php\", \"java\"]"
    pessoa.stack_as_array.should eq ["php", "java"]
  end

  describe "validations" do
    it "is invalid if apelido is too long" do
      operation = SavePessoa.new(apelido: "abcdefghijklmnopqrstuvwxyz0123456789")
      operation.valid?.should be_false
    end
  end

  describe "search" do
    before_each do
      PessoaFactory.create
    end

    it "should be nil" do
      pessoa = PessoaQuery.new.id(UUID.new("123e4567-e89b-12d3-a456-426655440000")).first?
      pessoa.should be_nil
    end

    it "should find partial nome" do
      pessoa = PessoaQuery.search("berto").first
      pessoa.nome.should eq("José Roberto")
    end

    it "should find partial apelido" do
      pessoa = PessoaQuery.search("zinho").first
      pessoa.apelido.should eq("zezinho")
    end

    it "should find one of the stack elements" do
      pessoa = PessoaQuery.search("ruby").first
      pessoa.stack.try &.should contain("java")
    end
  end
end
