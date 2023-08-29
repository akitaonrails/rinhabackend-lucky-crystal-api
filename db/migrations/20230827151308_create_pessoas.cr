class CreatePessoas::V20230827151308 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Pessoa) do
      primary_key id : UUID

      add apelido : String, unique: true
      add nome : String
      add nascimento : Time?
      add stack : String?
    end

    enable_extension "pg_trgm"

    execute <<-SQL
    CREATE INDEX pessoas_search_idx ON pessoas USING gin (apelido gin_trgm_ops, nome gin_trgm_ops, stack gin_trgm_ops);
    SQL
  end

  def rollback
    disable_extension "pg_trgm"
    drop table_for(Pessoa)
  end
end
