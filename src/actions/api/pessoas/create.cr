class Api::Pessoas::Create < ApiAction
  post "/pessoas" do
    pessoa = build_pessoa(params)
    unless pessoa
      return head 422
    end

    begin
      operation = build_operation(pessoa)
      if operation.valid?
        json = warmup_cache(pessoa)
        BatchInsertEvent.publish(operation)
        response.headers["Location"] = Api::Pessoas::Show.url(pessoa_id: pessoa.id)
        raw_json(json, HTTP::Status::CREATED)
      else
        head 400
      end
    rescue
      head 422
    end
  end

  def build_pessoa(params) : Pessoa?
    Pessoa.from_params(params)
  rescue e
    nil
  end

  def build_operation(pessoa : Pessoa)
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
