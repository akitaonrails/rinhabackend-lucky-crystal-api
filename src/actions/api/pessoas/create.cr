class Api::Pessoas::Create < ApiAction
  post "/pessoas" do
    data = params.nested(:pessoa)
    SavePessoa.create(apelido: data["apelido"], nome: data["nome"], nascimento_as_string: data["nascimento"], stack: data["stack"]) do |operation, pessoa|
      if pessoa
        json(PessoaSerializer.new(pessoa), HTTP::Status::CREATED)
      else
        raise UnprocessableError.new("invalid pessoa")
      end
    end
  end
end
