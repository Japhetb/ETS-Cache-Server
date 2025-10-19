defmodule EtsCacheServer.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [CacheServer]
    opts = [strategy: :one_for_one, name: EtsCacheServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
