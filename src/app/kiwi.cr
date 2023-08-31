require "kiwi/redis_store"

class KiwiCache
  property storage : Kiwi::Store

  def initialize(@storage = Kiwi::RedisStore.new(REDIS))
  end

  def fetch(key : String, &block) : String?
    storage.fetch(key) do
      yield
    end
  end

  def read(key : String) : String?
    storage.get(key)
  end

  def write(key : String, value : String) : String
    storage.set(key, value)
    value
  end

  delegate clear, to: storage
end

CACHE = KiwiCache.new
