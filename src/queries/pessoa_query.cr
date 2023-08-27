class PessoaQuery < Pessoa::BaseQuery
  def self.search(term)
    new.searchable.ilike("%#{term}%")
  end
end
