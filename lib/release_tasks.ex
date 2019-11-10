defmodule ReleaseTasks do
  defstruct [:app, :repo]

  def create(rt = %ReleaseTasks{app: app, repo: repo}) do
    load(app)
    app = Keyword.get(repo.config(), :otp_app)

    ReleaseTasks.Common.with_running_repo(repo, fn ->
      IO.puts("Creating database for #{app}")
      repo.__adapter__().storage_up(repo.config())
    end)

    :ok
  end

  def migrate(rt = %ReleaseTasks{app: app, repo: repo}) do
    load(app)
    path = Application.app_dir(app, "priv/repo/migrations")

    ReleaseTasks.Common.with_running_repo(repo, fn ->
      Ecto.Migrator.run(repo, path, :up, all: true)
    end)

    :ok
  end

  defp load(otp_app) do
    IO.puts("Loading #{otp_app}..")
    Application.load(otp_app)
  end
end
