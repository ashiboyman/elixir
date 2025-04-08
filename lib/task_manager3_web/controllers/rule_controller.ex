defmodule TaskManager3Web.RuleController do
  use TaskManager3Web, :controller
  alias TaskManager3.Rules

  def index(conn, _params) do
    emoji = ~w(🎂 😍😎 😒😒🤷‍♂️🤞) |> Enum.random()

    rule = Rules.list_rules()
    case TaskManager3.API.get_posts() do
      {:ok, posts} ->
        # Handle the posts data
        IO.inspect(posts)
      {:error, reason} ->
        # Handle the error
        IO.puts("Error: #{reason}")
    end
    HTTPoison.get("https://httpbin.org/get")
    render(conn, :index, emoji: emoji, rules: rule)
  end
end
