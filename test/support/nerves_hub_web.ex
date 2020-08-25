defmodule NervesHubCoreTest.NervesHubWeb do
  alias Ecto.Migrator

  @tmp File.cwd!() |> Path.join("test/tmp")

  def start do
    # Mix.Tasks.Ecto.Drop.run(["--repo", "NervesHubWebCore.Repo"])
    # Mix.Tasks.Ecto.Create.run(["--repo", "NervesHubWebCore.Repo"])
    # Mix.Tasks.Ecto.Drop.run(["--repo", "NervesHubCA.Repo"])
    # Mix.Tasks.Ecto.Create.run(["--repo", "NervesHubCA.Repo"])
    File.rm_rf(@tmp)

    nerves_hub_web_path = Mix.Project.deps_paths()[:nerves_hub_web]
    Code.compile_file(Path.join(nerves_hub_web_path, "test/support/fwup.ex"))
    Code.compile_file(Path.join(nerves_hub_web_path, "test/support/fixtures.ex"))

    pki_path = Path.join(@tmp, "pki")
    File.mkdir_p(pki_path)

    ssl_path = Path.join(@tmp, "ssl")
    File.mkdir_p(ssl_path)

    Mix.Tasks.NervesHubCa.Init.run(["--path", pki_path])

    ["root-ca.pem", "server-root-ca.pem", "user-root-ca.pem"]
    |> Enum.each(fn filename ->
      pki = Path.join(pki_path, filename)
      ssl = Path.join(ssl_path, filename)
      File.cp(pki, ssl)
    end)

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
