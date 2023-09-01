class Api::Pessoas::Count < ApiAction
  include Lucky::SkipRouteStyleCheck

  @@counter = 0

  def self.incr
    @@counter += 1
  end

  get "/contagem-pessoas" do
    BatchInsertEvent.flush!
    plain_text "counter: #{@@counter}, sql: #{PessoaQuery.count}"
  end
end
