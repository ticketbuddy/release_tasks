defmodule ReleaseTasks.Common do
  @start_apps [:crypto, :logger, :ssl, :postgrex, :ecto_sql]

  def with_running_repo(repo, action) do
    IO.puts("Starting dependencies..")
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    IO.puts("Starting repo..")
    repo.start_link(pool_size: 2)

    action.()

    IO.puts("Success!")
    :init.stop()
  end
end