class Api::Pessoas::Create < ApiAction
  post "/pessoas" do
    pessoa = begin
      Pessoa.from_hash({
        id:         UUID.random,
        apelido:    params.get("apelido"),
        nome:       params.get("nome"),
        nascimento: params.get("nascimento"),
        stack:      params.get("stack"),
      })
    rescue e
      raise UnprocessableError.new("invalid pessoa #{params.inspect} - #{e.message}")
    end

    json = CACHE.fetch(pessoa.id.to_s, as: String, expires_in: 30.seconds) do
      PessoaSerializer.new(pessoa).render.to_json
    end

    BatchInsertEvent.publish pessoa.to_tuple
    response.headers["Location"] = Api::Pessoas::Show.url(pessoa_id: pessoa.id)
    raw_json(json, HTTP::Status::CREATED)
  end
end
