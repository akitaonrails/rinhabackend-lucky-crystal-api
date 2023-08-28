require "../spec_helper"

describe Api::Pessoas::Index do
  it "should fail if request without param t" do
    response = ApiClient.exec(Api::Pessoas::Index)
    response.status.should eq HTTP::Status::BAD_REQUEST
  end

  it "should find the newly created record" do
    pessoa = PessoaFactory.create
    response = ApiClient.exec(Api::Pessoas::Index, t: "berto" )
    response.status.should eq HTTP::Status::OK

    result = Array(Hash(String, JSON::Any)).from_json(response.body)
    result.size.should eq 1
    result.first["nome"].should eq "José Roberto"
  end
end

describe Api::Pessoas::Show do
  it "should return 404 if nothing found" do
    response = ApiClient.exec(Api::Pessoas::Show.with("123e4567-e89b-12d3-a456-426655440000"))
    response.status.should eq HTTP::Status::NOT_FOUND
  end

  it "should find new record" do
    pessoa = PessoaFactory.create
    response = ApiClient.exec(Api::Pessoas::Show.with(pessoa.id))
    response.status.should eq HTTP::Status::OK

    result = Hash(String, JSON::Any).from_json(response.body)
    result["nome"].should eq "José Roberto"
  end
end
