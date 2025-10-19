# 🧠 Elixir ETS Cache Server
A simple in-memory caching service built with **Elixir**, using **Erlang Term Storage (ETS)** for fast key-value storage.

## 🚀 Features
  - ⚡ Super-fast reads and writes via ETS  
  - 🧩 Optional TTL (time-to-live) for cache entries  
  - 🧼 Automatic cleanup of expired items  
  - 🧵 Thread-safe access using a GenServer  

---

## 📦 Requirements
  - Elixir ≥ 1.14  
  - Erlang/OTP ≥ 26  

---

## 🛠️ Installation

Clone the project and fetch dependencies:

```bash
git clone https://github.com/Japhetb/ETS-Cache-Server.git
cd ets_cache_server
mix deps.get
```

Start an interactive shell:

```bash
iex -S mix
```

---

## 📘 Usage Example

### Store a value
```elixir
EtsCacheServer.add_to_cache("foo", "bar", 10000)
# => :ok
```

### Retrieve it
```elixir
EtsCacheServer.fetch_from_cache("foo")
# => {:ok, "bar"}
```

### If the item has expired
```elixir
EtsCacheServer.fetch_from_cache("foo")
# => {:error, :not_found}
```

### Fetch all cache entries
```elixir
EtsCacheServer.fetch_all_from_cache()
# => {:ok, [{"foo", "bar", 1760899715505}]}
```

--- 
