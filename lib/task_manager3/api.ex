defmodule TaskManager3.API do
  @base_url "https://jsonplaceholder.typicode.com"
  @timeout 10_000 # 10 seconds

  def get_posts do
    case HTTPoison.get("#{@base_url}/posts", [], [timeout: @timeout, recv_timeout: @timeout]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Request failed with status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed: #{inspect(reason)}"}
    end
  end
end
