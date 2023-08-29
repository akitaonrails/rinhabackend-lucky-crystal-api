require "lucky_cache"

LuckyCache.configure do |settings|
  settings.storage = LuckyCache::MemoryStore.new
  settings.default_duration = 1.minute
end

CACHE = LuckyCache.settings.storage
