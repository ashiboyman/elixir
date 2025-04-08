defmodule TaskManager3Web.PageController do
  use TaskManager3Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: {TaskManager3Web.Layouts ,:simple})
  end
end
