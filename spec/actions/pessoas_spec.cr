require "../spec_helper"

describe Api::Pessoas::Index do
  it "should fail if request without param t" do
    response = ApiClient.exec(Api::Pessoas::Index)
    response.status.should eq HTTP::Status::BAD_REQUEST
  end
end
