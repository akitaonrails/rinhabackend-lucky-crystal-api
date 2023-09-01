class Api::Pessoas::Show < ApiAction
  JSON_HEADER = HTTP::Headers{"Content-Type" => "application/json"}

  get "/pessoas/:pessoa_id" do
    # raw_json "{}", HTTP::Status::OK
    uuid = UUID.new(pessoa_id)

    begin
      json_pessoa = CACHE.fetch(uuid.to_s) do
        if pessoa = PessoaQuery.new.id(uuid).first?
          PessoaSerializer.new(pessoa).render.to_json
        else
          nil
        end
      end

      if json_pessoa.blank?
        head 404
      else
        raw_json(json_pessoa || "{}", HTTP::Status::OK)
      end
    rescue e
      head 400
    end
  end
end
