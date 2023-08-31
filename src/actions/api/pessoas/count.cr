class Api::Pessoas::Count < ApiAction
  include Lucky::SkipRouteStyleCheck

  get "/contagem-pessoas" do
    BatchInsertEvent.flush!
    plain_text PessoaQuery.count.to_s
  end
end
