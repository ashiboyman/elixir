defmodule TaskManager3Web.RuleController do
  use TaskManager3Web, :controller
  alias TaskManager3.Rules

  def index(conn, _params) do
    emoji = ~w(🎂 😍😎 😒😒🤷‍♂️🤞) |> Enum.random()

    rule = Rules.list_rules()
   
    render(conn, :index, emoji: emoji, rules: rule)
  end
end
