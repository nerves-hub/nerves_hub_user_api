defmodule NervesHubCoreTest.NervesHubWeb do
  alias Ecto.Migrator

  def start do
    # Mix.Tasks.Ecto.Drop.run(["--repo", "NervesHubWebCore.Repo"])
    # Mix.Tasks.Ecto.Create.run(["--repo", "NervesHubWebCore.Repo"])
    # Mix.Tasks.Ecto.Drop.run(["--repo", "NervesHubCA.Repo"])
    # Mix.Tasks.Ecto.Create.run(["--repo", "NervesHubCA.Repo"])

    Application.ensure_all_started(:nerves_hub_ca)
    run_migrations_for(:nerves_hub_ca)

    Application.ensure_all_started(:nerves_hub_web_core)
    run_migrations_for(:nerves_hub_web_core)
    run_seed_script("#{seed_path(:nerves_hub_web_core)}/seeds.exs")
    Application.ensure_all_started(:nerves_hub_api)
  end

  defp run_migrations_for(app) do
    IO.puts("Running migrations for #{app}")

    app
    |> Application.get_env(:ecto_repos, [])
    |> Enum.each(&Migrator.run(&1, migrations_path(app), :up, all: true))
  end

  def run_seed_script(seed_script) do
    IO.puts("Running seed script #{seed_script}...")
    Code.eval_file(seed_script)
  end

  defp migrations_path(app), do: priv_dir(app, ["repo", "migrations"])

  defp seed_path(app), do: priv_dir(app, ["repo"])

  defp priv_dir(app, path) when is_list(path) do
    case :code.priv_dir(app) do
      priv_path when is_list(priv_path) or is_binary(priv_path) ->
        Path.join([priv_path] ++ path)

      {:error, :bad_name} ->
        raise ArgumentError, "unknown application: #{inspect(app)}"
    end
  end
end
