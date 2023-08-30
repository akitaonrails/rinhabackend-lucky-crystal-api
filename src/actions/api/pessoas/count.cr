class Api::Pessoas::Count < ApiAction
  include Lucky::SkipRouteStyleCheck

  get "/contagem-pessoas" do
    BatchInsertEvent.publish(nil)
    if LuckyEnv.production?
      # give a bit of time to flush the last queued inserts
      # the stress test instructions says it won't count the time for this request
      sleep(1)
    end
    plain_text PessoaQuery.count.to_s
  end
end
