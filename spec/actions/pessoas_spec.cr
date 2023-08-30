require "../spec_helper"
require "webmock"

describe Api::Pessoas::Index do
  it "should fail if request without param t" do
    response = ApiClient.exec(Api::Pessoas::Index)
    response.status.should eq HTTP::Status::BAD_REQUEST
  end

  it "should find the newly created record" do
    PessoaFactory.create
    response = ApiClient.exec(Api::Pessoas::Index, t: "berto")
    response.status.should eq HTTP::Status::OK

    result = Array(Hash(String, JSON::Any)).from_json(response.body)
    result.size.should eq 1
    result.first["nome"].should eq "José Roberto"
  end
end

describe Api::Pessoas::Show do
  it "should return 404 if nothing found" do
    pessoa_id = "123e4567-e89b-12d3-a456-426655440000"
    url = "http://localhost:3000/pessoas/#{pessoa_id}"
    WebMock.stub(:get, url).to_return do |_|
      HTTP::Client::Response.new(404)
    end

    response = ApiClient.exec(Api::Pessoas::Show.with(pessoa_id))
    response.status.should eq HTTP::Status::NOT_FOUND
  end

  it "should find new record" do
    pessoa = PessoaFactory.create
    response = ApiClient.exec(Api::Pessoas::Show.with(pessoa.id))
    response.status.should eq HTTP::Status::OK

    result = Hash(String, JSON::Any).from_json(response.body)
    result["nome"].should eq "José Roberto"
  end

  it "should try to call the second app instance to use as a pseudo cache" do
    json = PessoaSerializer.new(PessoaFactory.create).render.to_json
    pessoa_id = "dbde7d04-3fc8-4217-90e3-39b19eafb38d"
    url = "http://localhost:3000/pessoas/#{pessoa_id}"
    WebMock.stub(:get, url).to_return(json)

    response = ApiClient.exec(Api::Pessoas::Show.with(pessoa_id))
    response.status.should eq HTTP::Status::OK
  end
end

describe Api::Pessoas::Create do
  it "should create new pessoa" do
    response = ApiClient.exec(Api::Pessoas::Create,
      apelido: "ana", nome: "Ana Barbosa",
      nascimento: "2000-01-01", stack: ["php", "python"])
    response.status.should eq HTTP::Status::CREATED
    response.headers["Location"].should match %r{/pessoas/[0-9a-f-]{36}}
  end

  it "should create new pessoa even with invalid stack" do
    response = ApiClient.exec(Api::Pessoas::Create,
      apelido: "ana", nome: "Ana Barbosa",
      nascimento: "2000-01-01", stack: nil)
    response.status.should eq HTTP::Status::CREATED
    pessoa = PessoaQuery.new.last
    pessoa.stack_as_array.should eq [] of String

    response = ApiClient.exec(Api::Pessoas::Create,
      apelido: "ana", nome: "Ana Barbosa",
      nascimento: "2000-01-01", stack: 1)
    response.status.should eq HTTP::Status::CREATED
    pessoa = PessoaQuery.new.last
    pessoa.stack_as_array.should eq [] of String
  end

  it "should create 2 out of 3 pessoas even if one is a conflict" do
    Application.settings.batch_insert_size = 3

    response = ApiClient.exec(Api::Pessoas::Create,
      apelido: "ana", nome: "Ana Barbosa",
      nascimento: "2000-01-01", stack: ["php", "python"])
    response.status.should eq HTTP::Status::CREATED
    # queued
    PessoaQuery.count.should eq 0

    response = ApiClient.exec(Api::Pessoas::Create,
      apelido: "ana", nome: "Ana Barbosa",
      nascimento: "2000-01-01", stack: ["php", "python"])
    response.status.should eq HTTP::Status::CREATED
    # queued
    PessoaQuery.count.should eq 0

    response = ApiClient.exec(Api::Pessoas::Create,
      apelido: "jose", nome: "Jose Roberto",
      nascimento: "2000-02-01", stack: ["java", "ruby"])
    response.status.should eq HTTP::Status::CREATED
    # pulsar job should run and empty the queue with a bulk insert
    PessoaQuery.count.should eq 2

    # just to make sure this won't affect other tests
    Application.settings.batch_insert_size = 1
  end
end

describe Api::Pessoas::Count do
  it "should return correct db count" do
    PessoaFactory.create
    response = ApiClient.exec(Api::Pessoas::Count)
    response.status.should eq HTTP::Status::OK
    response.body.should eq "1"
  end
end
