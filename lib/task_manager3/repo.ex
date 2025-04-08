defmodule TaskManager3.Repo do
  use Ecto.Repo,
    otp_app: :task_manager3,
    adapter: Ecto.Adapters.Postgres
end
