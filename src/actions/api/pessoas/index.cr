class Api::Pessoas::Index < ApiAction
  get "/pessoas" do
    term = params.get?("t")

    if term.nil?
      head 400
    else
      query = PessoaQuery.search(term).map { |item| item }
      json(PessoaSerializer.for_collection(query))
    end
  end
end
