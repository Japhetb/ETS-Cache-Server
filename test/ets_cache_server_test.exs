defmodule EtsCacheServerTest do
  use ExUnit.Case

  setup_all do
    # Ensure CacheServer is running
    start_supervised(CacheServer)
    :ets.delete_all_objects(:ets_cache_table)
    :ok
  end

  describe "CacheServer.put/3 and get/1" do
    test "stores and retrieves values" do
      assert :ok = CacheServer.put("foo", "bar")
      assert {:ok, "bar"} = CacheServer.get("foo")

      CacheServer.put("temp", "123", 1)
      assert {:ok, "123"} = CacheServer.get("temp")
    end

    test "returns :not_found for missing keys" do
      assert {:error, :not_found} = CacheServer.get("missing_key")
    end

    test "overwrites existing keys" do
      CacheServer.put("test", 1)
      CacheServer.put("test", 2)
      assert {:ok, 2} = CacheServer.get("test")
    end
  end

  describe "CacheServer with TTL" do
    test "expires entries after TTL" do
      CacheServer.put("temp", "123", 1)
      assert {:ok, "123"} = CacheServer.get("temp")

      Process.sleep(150)
      assert {:error, :not_found} = CacheServer.get("temp")
    end

    test "keeps entries with :infinity TTL" do
      CacheServer.put("perm", "value", :infinity)
      Process.sleep(200)
      assert {:ok, "value"} = CacheServer.get("perm")
    end
  end
end
