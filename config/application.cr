# This file may be used for custom Application configurations.
# It will be loaded before other config files.
#
# Read more on configuration:
#   https://luckyframework.org/guides/getting-started/configuration#configuring-your-own-code

module Application
  Habitat.create do
    setting batch_insert_size : Int32
    setting other_server : String
  end
end

Application.configure do |settings|
  if LuckyEnv.test?
    settings.batch_insert_size = 1
  else
    settings.batch_insert_size = ENV["BATCH_INSERT_SIZE"]?.try(&.to_i) || 1
  end
  settings.other_server = ENV["OTHER_SERVER"]? || "http://localhost:3000"
end

# # In your application, call
# # `Application.settings.support_email` anywhere you need it.
# ```
