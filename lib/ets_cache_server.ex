defmodule EtsCacheServer do
  defdelegate add_to_cache(key, value, ttl),
  to: CacheServer,
  as: :put

  defdelegate fetch_from_cache(key),
  to: CacheServer,
  as: :get

  defdelegate fetch_all_from_cache(),
  to: CacheServer,
  as: :get_all
end
