defmodule ExplorerWeb.GrpcView do
  use ExplorerWeb, :view

  def render("error.json", %{error: %GRPC.RPCError{message: message, status: status}}) do
    %{
      message: message,
      status: status
    }
  end
end
