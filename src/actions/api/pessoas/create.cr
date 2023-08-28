class Api::Pessoas::Create < ApiAction
  post "/pessoas" do
    begin
      SavePessoa.create(apelido: params.get("apelido"),
        nome: params.get("nome"),
        nascimento_as_string: params.get("nascimento"),
        stack_as_string: params.get("stack")) do |operation, pessoa|
        if pessoa
          response.headers["Location"] = Api::Pessoas::Show.url(pessoa_id: pessoa.id)
          json(PessoaSerializer.new(pessoa), HTTP::Status::CREATED)
        else
          raise UnprocessableError.new("invalid pessoa")
        end
      end
    rescue PQ::PQError
      raise UnprocessableError.new("possible duplicate")
    end
  end
end
