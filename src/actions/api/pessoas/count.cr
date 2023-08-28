class Api::Pessoas::Count < ApiAction
  include Lucky::SkipRouteStyleCheck

  get "/contagem-pessoas" do
    plain_text PessoaQuery.new.select_count.to_s
  end
end
