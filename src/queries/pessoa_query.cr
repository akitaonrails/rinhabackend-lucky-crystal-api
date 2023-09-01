class PessoaQuery < Pessoa::BaseQuery
  def self.search(term)
    AppDatabase.query_all("SELECT ID, APELIDO, NOME, NASCIMENTO, STACK
      FROM PESSOAS
      WHERE SEARCHABLE ILIKE '%#{term}%'
      LIMIT 50", as: Pessoa)
  end

  def self.count
    new.select_count
  end
end
