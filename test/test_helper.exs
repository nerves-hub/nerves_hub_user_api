ExUnit.start()

opts = [timeout: 5_000, max_connections: 5]
:ok = :hackney_pool.start_pool(:nerves_hub_user_api, opts)

System.put_env("NERVES_LOG_DISABLE_PROGRESS_BAR", "true")

NervesHubCoreTest.NervesHubWeb.start()

Ecto.Adapters.SQL.Sandbox.mode(NervesHubWebCore.Repo, :manual)
