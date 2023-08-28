class Api::Pessoas::Show < ApiAction
  get "/pessoas/:pessoa_id" do
    uuid = nil
    begin
      uuid = UUID.new(pessoa_id)
    rescue exception
      raise BadRequestError.new("invalid uuid")
    end

    pessoa = PessoaQuery.new.id(uuid).first?

    if pessoa.nil?
      raise NotFoundError.new("Pessoa not found")
    else
      json(PessoaSerializer.new(pessoa))
    end
  end
end
