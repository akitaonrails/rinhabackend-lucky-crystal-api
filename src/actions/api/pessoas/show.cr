class Api::Pessoas::Show < ApiAction
  JSON_HEADER = HTTP::Headers{"Content-Type" => "application/json"}

  get "/pessoas/:pessoa_id" do
    cast_uuid = UUID.new(pessoa_id)

    json_pessoa = CACHE.fetch(cast_uuid.to_s, as: String) do
      pessoa = PessoaQuery.new.id(cast_uuid).first?

      if pessoa.nil?
        fetch_from_other_server(pessoa_id)
      else
        PessoaSerializer.new(pessoa).render.to_json
      end
    end

    if json_pessoa.blank?
      raise NotFoundError.new("Pessoa not found")
    else
      raw_json(json_pessoa)
    end
  end

  def fetch_from_other_server(pessoa_id)
    return "" unless LuckyEnv.production?

    uri = Application.settings.other_server + "/pessoas/#{pessoa_id}"
    response = HTTP::Client.get(uri, headers: JSON_HEADER)

    return "" unless response.status_code == 200

    response.body
  end
end
