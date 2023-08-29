class PessoaQuery < Pessoa::BaseQuery
  def self.search(term)
    new.apelido.ilike("%#{term}%").or(&.nome.ilike("%#{term}%")).or(&.stack.ilike("%#{term}%"))
  end
end
