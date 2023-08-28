class Api::Pessoas::Index < ApiAction
  get "/pessoas" do
    term = params.get?("t")

    if term.nil?
      raise BadRequestError.new("must have parameter 't'")
    else
      query = PessoaQuery.search(term)
      json(PessoaSerializer.for_collection(query))
    end
  end
end
