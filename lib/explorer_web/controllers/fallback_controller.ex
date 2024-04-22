defmodule ExplorerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ExplorerWeb, :controller

  def call(conn, {:error, %GRPC.RPCError{} = error}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ExplorerWeb.GrpcView)
    |> render("error.json", error: error)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ExplorerWeb.ErrorView)
    |> render(:"404")
  end
end
