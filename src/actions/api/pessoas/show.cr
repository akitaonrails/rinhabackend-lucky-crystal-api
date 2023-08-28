class Api::Pessoas::Show < ApiAction
  get "/pessoas/:pessoa_id" do
    pessoa = PessoaQuery.new.id(generate_uuid).first?

    if pessoa.nil?
      raise NotFoundError.new("Pessoa not found")
    else
      json(PessoaSerializer.new(pessoa))
    end
  end

  def generate_uuid
    begin
      return UUID.new(pessoa_id)
    rescue exception
      raise BadRequestError.new("invalid uuid")
    end
  end
end
