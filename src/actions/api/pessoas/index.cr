class Api::Pessoas::Index < ApiAction
  get "/pessoas" do
    if term = params.get?("t")
      # raw_json("[]", HTTP::Status::OK)
      query = PessoaQuery.search(term).map { |item| item }
      json(PessoaSerializer.for_collection(query))
    else
      head 400
    end
  end
end
