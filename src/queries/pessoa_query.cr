class PessoaQuery < Pessoa::BaseQuery
  def self.search(term)
    query = "%#{term}%"
    new.apelido.ilike(query)
      .or(&.nome.ilike(query))
      .or(&.stack.ilike(query))
  end

  def self.count
    new.select_count
  end
end
