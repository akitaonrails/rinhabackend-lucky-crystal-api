class Api::Pessoas::Create < ApiAction
  post "/pessoas" do
    pessoa = build_pessoa(params)
    operation = build_operation(pessoa)

    if operation.valid?
      json = warmup_cache(pessoa)
      BatchInsertEvent.publish(operation)
      response.headers["Location"] = Api::Pessoas::Show.url(pessoa_id: pessoa.id)
      raw_json(json, HTTP::Status::CREATED)
    else
      raise BadRequestError.new("invalid pessoa #{operation.errors}")
    end
  end

  def build_pessoa(params)
    Pessoa.from_params(params)
  rescue e
    raise UnprocessableError.new("invalid pessoa #{params.get("nascimento")}, #{params.get("stack")} - #{e.message}")
  end

  def build_operation(pessoa)
    SavePessoa.build(pessoa).tap do |operation|
      operation.before_save
    end
  end

  def warmup_cache(pessoa)
    CACHE.fetch(pessoa.id.to_s, as: String, expires_in: 30.seconds) do
      PessoaSerializer.new(pessoa).render.to_json
    end
  end
end
