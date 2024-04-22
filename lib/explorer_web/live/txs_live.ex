defmodule ExplorerWeb.TxsLive do
  use ExplorerWeb, :live_view
  import Cosmos.Tx.V1beta1.Service.Stub
  alias Cosmos.Tx.V1beta1.GetTxsEventRequest, as: GetTxs
  alias Cosmos.Tx.V1beta1.OrderBy

  def mount(_params, _session, socket) do
    Explorer.Node.subscribe("tendermint/event/NewBlock")

    # req =
    #   GetTxs.new(events: ["tx.height > 0"], order_by: OrderBy.value(:ORDER_BY_DESC), limit: 25)

    # IO.inspect(req)

    # {:ok, %{txs: txs}} =
    #   get_txs_event(
    #     Explorer.Node.channel(),
    #     req
    #   )

    # IO.inspect(txs)
    {:ok, assign(socket, :txs, [])}
  end

  def handle_info(%{block: %{data: %{txs: txs}} = x}, socket) do
    {:noreply, assign(socket, :txs, Enum.concat(txs, socket.assigns.txs))}
  end
end
