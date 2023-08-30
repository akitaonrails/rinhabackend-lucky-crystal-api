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
    buffer = Deque(PessoaTuple).new(0)
    PessoaQuery.truncate
    puts PessoaQuery.count

    File.open("./tasks/db/seed/pessoas-payloads.tsv", "r").each_line do |line|
      next if line.starts_with?("payload")
      puts line
      payload =
        Hash(String, String | Array(String) | Nil | Int32).from_json(line)

      begin
        nascimento = payload["nascimento"]?.as(String).gsub("\"", "")
        stack = begin
          payload["stack"]?.as(Array(String))
        rescue
          [] of String
        end

        pessoa = PessoaTuple.new(id: UUID.random,
          apelido: payload["apelido"].as(String),
          nome: payload["nome"].as(String),
          nascimento: Time.parse(nascimento, "%Y-%m-%d", Time::Location.local),
          stack: payload["stack"]?.try &.to_json)
        buffer.push pessoa
      rescue Time::Format::Error
        puts "invalid time #{payload["nascimento"]?}"
      rescue ArgumentError
        puts "invalid time or stack #{payload["nascimento"]?}, #{payload["stack"]?}"
      end

      if buffer.size > 10
        tmp_buffer = [] of SavePessoa
        counter = 10
        while counter > 0 && !buffer.empty?
          operation = SavePessoa.from_tuple(buffer.shift)

          if operation.valid?
            tmp_buffer.push(operation)
          end
          counter -= 1
        end
        begin
          SavePessoa.import(tmp_buffer)
        rescue e
          puts e.message
          puts e.backtrace
          puts line
        end
      end
    end

    if buffer.size > 0
      tmp_buffer = [] of SavePessoa
      while !buffer.empty?
        operation = SavePessoa.from_tuple(buffer.shift)

        if operation.valid?
          tmp_buffer.push(operation)
        end
      end

      begin
        SavePessoa.import(tmp_buffer)
      rescue e
        puts e.message
        puts e.backtrace
      end
    end

    puts PessoaQuery.count
    puts "Done adding sample data"
  end
end
