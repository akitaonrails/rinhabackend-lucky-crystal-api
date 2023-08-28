class CreatePessoas::V20230827151308 < Avram::Migrator::Migration::V1
  def migrate
    # Learn about migrations at: https://luckyframework.org/guides/database/migrations
    create table_for(Pessoa) do
      primary_key id : UUID

      add apelido : String, unique: true
      add nome : String
      add nascimento : Time
      add stack : String
    end

    enable_extension "pg_trgm"

    execute <<-SQL
    ALTER TABLE pessoas
      ADD searchable text GENERATED ALWAYS AS (
          nome || ' ' || apelido || ' ' || COALESCE(stack::text, ' ')
      ) STORED;
    SQL
  end

  def rollback
    disable_extension "pg_trgm"
    drop table_for(Pessoa)
  end
end
