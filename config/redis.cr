require "redis"

class RedisConfig
  Habitat.create do
    setting host : String
    setting port : Int32
  end

  def self.connect
    Redis::PooledClient.new(self.settings.host, self.settings.port)
  end
end

RedisConfig.configure do |settings|
  settings.host = ENV["REDIS_HOST"]? || "localhost"
  settings.port = ENV["REDIS_PORT"]?.try(&.to_i) || 6379
end

REDIS = RedisConfig.connect
