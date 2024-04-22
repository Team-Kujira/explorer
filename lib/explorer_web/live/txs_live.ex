defmodule ExplorerWeb.TxsLive do
  use ExplorerWeb, :live_view
  import Cosmos.Tx.V1beta1.Service.Stub
  alias Cosmos.Tx.V1beta1.GetTxsEventRequest, as: GetTxs
  alias Cosmos.Tx.V1beta1.OrderBy

  def mount(_params, _session, socket) do
    Explorer.Node.subscribe("tendermint/event/NewBlock")



    # IO.inspect(txs)
    {:ok, assign(socket, :txs, [])}
  end

  def handle_info(%{block: %{data: %{txs: txs}} = x}, socket) do
    {:noreply, assign(socket, :txs, Enum.concat(txs, socket.assigns.txs))}
  end
end
