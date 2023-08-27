abstract class BaseModel < Avram::Model
  macro default_columns
    primary_key id : UUID
  end

  def self.database : Avram::Database.class
    AppDatabase
  end
end
