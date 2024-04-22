defmodule ExplorerWeb.TxsController do
  alias ExplorerWeb.TxsLive
  use ExplorerWeb, :controller
  import Cosmos.Tx.V1beta1.Service.Stub
  alias Cosmos.Tx.V1beta1.GetTxRequest, as: GetTx

  action_fallback ExplorerWeb.FallbackController

  def index(conn, _params) do
    live_render(conn, TxsLive)
  end

  def show(conn, %{"hash" => hash}) do
    with {:ok, %{tx: tx}} <- get_tx(Explorer.Node.channel(), GetTx.new(hash: hash)) do
      render(conn, "show.html")
    end
  end
end