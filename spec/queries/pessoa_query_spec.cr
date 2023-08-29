require "../spec_helper"

describe PessoaQuery do
  before_each do
    PessoaFactory.create
  end

  it "should find by apelido" do
    pessoa = PessoaQuery.new.apelido("zezinho").first
    pessoa.nome.should eq "José Roberto"
  end

  it "should find by ilike on apelido" do
    pessoa = PessoaQuery.search("zinho").first
    pessoa.nome.should eq "José Roberto"
  end

  it "should return an array" do
    pessoa = PessoaQuery.search("berto").map { |item| item }
    pessoa.size.should eq 1
  end
end
