class Api::Pessoas::Show < ApiAction
  get "/pessoas/:pessoa_id" do
    pessoa = PessoaQuery.new.id(cast_uuid).first?

    if pessoa.nil?
      raise NotFoundError.new("Pessoa not found")
    else
      json(PessoaSerializer.new(pessoa))
    end
  end

  def cast_uuid
    begin
      return UUID.new(pessoa_id)
    rescue exception
      raise BadRequestError.new("invalid uuid")
    end
  end
end
