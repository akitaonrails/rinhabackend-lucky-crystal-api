class Api::Pessoas::Create < ApiAction
  post "/pessoas" do
    pessoa = build_pessoa(params)
    return head 422 unless pessoa

    begin
      if (operation = build_operation(pessoa)).valid?
        json = PessoaSerializer.new(pessoa).render.to_json
        spawn { warmup_cache(pessoa, json) }
        spawn { BatchInsertEvent.publish(operation) }

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

  def warmup_cache(pessoa, json)
    CACHE.fetch(pessoa.id.to_s) do
      json
    end
  end
end
