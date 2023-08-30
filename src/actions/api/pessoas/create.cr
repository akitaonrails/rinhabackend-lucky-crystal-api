class Api::Pessoas::Create < ApiAction
  post "/pessoas" do
    pessoa = build_pessoa(params)
    operation = build_operation(pessoa)
    json = warmup_cache(pessoa)

    BatchInsertEvent.publish(operation)
    response.headers["Location"] = Api::Pessoas::Show.url(pessoa_id: pessoa.id)
    raw_json(json, HTTP::Status::CREATED)
  end

  def build_pessoa(params)
    Pessoa.from_params(params)
  rescue e
    raise UnprocessableError.new("invalid pessoa #{params.get("nascimento")}, #{params.get("stack")} - #{e.message}")
  end

  def build_operation(pessoa)
    operation = SavePessoa.build(pessoa)
    unless operation.valid?
      raise BadRequestError.new("invalid pessoa #{operation.errors}")
    end
    operation
  end

  def warmup_cache(pessoa)
    CACHE.fetch(pessoa.id.to_s, as: String, expires_in: 30.seconds) do
      PessoaSerializer.new(pessoa).render.to_json
    end
  end
end
