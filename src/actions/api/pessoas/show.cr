class Api::Pessoas::Show < ApiAction
  get "/pessoas/:pessoa_id" do
    # raw_json "{}", HTTP::Status::OK
    begin
      json_pessoa = CACHE.fetch(pessoa_id) do
        if pessoa = PessoaQuery.find_first?(pessoa_id)
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
