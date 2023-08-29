class PessoaQuery < Pessoa::BaseQuery
  def self.search(term)
    query = "%#{term}%"
    new.apelido.ilike(query).
      or(&.nome.ilike(query)).
      or(&.stack.ilike(query))
  end
end
