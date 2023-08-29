require "lucky_cache"

LuckyCache.configure do |settings|
  if LuckyEnv.test?
    settings.storage = LuckyCache::NullStore.new
  else
    settings.storage = LuckyCache::MemoryStore.new
  end
  settings.default_duration = 1.minute
end

CACHE = LuckyCache.settings.storage
