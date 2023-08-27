class Api::Pessoas::Index < ApiAction
  get "/pessoas" do
    query = params.get?("t")

    if query.nil?
      raise BadRequestError.new("must have parameter 't'")
    else
      json(PessoaQuery.search(query).map { |record| PessoaSerializer.new(record) })
    end
  end
end
