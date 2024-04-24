defmodule ExplorerWeb.TxsController do
  use ExplorerWeb, :controller
  import Cosmos.Tx.V1beta1.Service.Stub
  alias Cosmos.Tx.V1beta1.GetTxRequest, as: GetTx

  action_fallback ExplorerWeb.FallbackController

  def show(conn, %{"hash" => hash}) do
    with {:ok, %{tx: tx, tx_response: tx_response}} <-
           get_tx(Explorer.Node.channel(), GetTx.new(hash: hash)) do
      conn = conn |> assign(:tx, tx) |> assign(:hash, hash) |> assign(:tx_response, tx_response)
      render(conn, "show.html")
    end
  end
end
