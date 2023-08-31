require "../../../spec/support/factories/**"

# Add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::Seed::RequiredData` if you need to create data *required* for your
# app to work.
class Db::Seed::SampleData < LuckyTask::Task
  summary "Add sample database records helpful for development"

  def call
    # Using an Avram::Factory:
    #
    # Use the defaults, but override just the email
    # UserFactory.create &.email("me@example.com")

    # Using a SaveOperation:
    # ```
    # SignUpUser.create!(email: "me@example.com", password: "test123", password_confirmation: "test123")
    # ```
    #
    # You likely want to be able to run this file more than once. To do that,
    # only create the record if it doesn't exist yet:
    # ```
    # if UserQuery.new.email("me@example.com").none?
    #   SignUpUser.create!(email: "me@example.com", password: "test123", password_confirmation: "test123")
    # end
    # ```
    PessoaQuery.truncate
    Application.settings.batch_insert_size = 100
    backend = Log::IOBackend.new
    backend.formatter = Lucky::PrettyLogFormatter.proc
    Log.dexter.configure(:fatal, backend)

    File.open("./tasks/db/seed/pessoas-payloads.tsv", "r").each_line do |line|
      next if line.starts_with?("payload")
      print "."
      payload =
        Hash(String, String | Array(String) | Nil | Int32).from_json(line)

      begin
        # clean up input data
        nascimento = payload["nascimento"]?.as(String).gsub("\"", "")
        stack = begin
          payload["stack"]?.as(Array(String))
        rescue
          [] of String
        end

        # validate input
        operation = SavePessoa.new(id: UUID.random,
          apelido: payload["apelido"].as(String),
          nome: payload["nome"].as(String),
          nascimento: Time.parse(nascimento, "%Y-%m-%d", Time::Location.local),
          stack: payload["stack"]?.try &.to_json)

        BatchInsertEvent.publish(operation)
      rescue e
        # puts "ERROR: #{e.message} #{payload["nascimento"]?}, #{payload["stack"]?}"
        print "F"
      end
    end
    # just to flush left over ops in the queue
    BatchInsertEvent.flush!
    puts PessoaQuery.count
    puts "Done adding sample data"
  end
end
