require "redis"

class RedisConfig
  Habitat.create do
    setting host : String
    setting port : Int32
    setting pool_size : Int32
    setting pool_timeout : Float32
  end

  def self.connect
    # host = "localhost", port = 6379, unixsocket = nil, password = nil,
    # database = nil, url = nil, ssl = false, ssl_context = nil,
    # dns_timeout = nil, connect_timeout = nil, reconnect = true, command_timeout = nil,
    # namespace : String? = ""
    Redis::PooledClient.new(self.settings.host, self.settings.port, nil, nil,
      nil, nil, false, nil, 1.minute, 1.minute, true, 1.minute, "",
      pool_size: self.settings.pool_size, pool_timeout: self.settings.pool_timeout)
  end
end

RedisConfig.configure do |settings|
  settings.host = ENV["REDIS_HOST"]? || "localhost"
  settings.port = ENV["REDIS_PORT"]?.try(&.to_i) || 6379
  settings.pool_size = ENV["REDIS_POOL_SIZE"]?.try(&.to_i) || 5
  settings.pool_timeout = ENV["REDIS_POOL_TIMEOUT"]?.try(&.to_f32) || (5.0).to_f32
end

REDIS = RedisConfig.connect
