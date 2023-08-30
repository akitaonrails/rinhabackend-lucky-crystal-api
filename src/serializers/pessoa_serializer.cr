class PessoaSerializer < BaseSerializer
  def initialize(@pessoa : Pessoa)
  end

  def render
    {
      id:         @pessoa.id,
      apelido:    @pessoa.apelido,
      nome:       @pessoa.nome,
      nascimento: @pessoa.nascimento,
      stack:      @pessoa.stack_as_array,
    }
  end
end
