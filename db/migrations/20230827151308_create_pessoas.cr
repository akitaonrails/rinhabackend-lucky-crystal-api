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
    ALTER TABLE PESSOAS
    ADD COLUMN searchable TEXT GENERATED ALWAYS AS (
      LOWER(NOME || APELIDO || STACK)
    ) STORED
    SQL

    execute <<-SQL
    CREATE INDEX IF NOT EXISTS index_pessoas_on_id ON public.pessoas (id);
    SQL

    execute <<-SQL
    CREATE UNIQUE INDEX IF NOT EXISTS index_pessoas_on_apelido ON public.pessoas USING btree (apelido);
    SQL

    # run lucky db.schema.dump and modify the .sql file to have CREATE INDEX CONCURRENTLY
    execute <<-SQL
    CREATE INDEX IF NOT EXISTS IDX_PESSOAS_SEARCHABLE ON PESSOAS
    USING GIST (searchable GIST_TRGM_OPS(SIGLEN=64));
    SQL
  end

  def rollback
    disable_extension "pg_trgm"
    drop table_for(Pessoa)
  end
end
