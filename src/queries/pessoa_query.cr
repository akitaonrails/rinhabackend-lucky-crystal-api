class PessoaQuery < Pessoa::BaseQuery
  def self.search(term)
    AppDatabase.query_all("SELECT ID, APELIDO, NOME, NASCIMENTO, STACK
      FROM PESSOAS
      WHERE SEARCHABLE ILIKE '%#{term}%'
      LIMIT 50", as: Pessoa)
  end

  # doing direct sql query just to avoid UUID.new(person_id) and then back to string for the query
  def self.find_first?(id)
    AppDatabase.query_all("SELECT ID, APELIDO, NOME, NASCIMENTO, STACK
      FROM PESSOAS
      WHERE ID = '#{id}' LIMIT 1", as: Pessoa).first?
  end

  def self.count
    new.select_count
  end
end
