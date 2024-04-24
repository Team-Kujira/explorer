defmodule ExplorerWeb.TxsLive do
  use ExplorerWeb, :live_view
  import Cosmos.Tx.V1beta1.Service.Stub
  alias Cosmos.Tx.V1beta1.GetTxsEventRequest, as: GetTxs
  alias Cosmos.Tx.V1beta1.OrderBy

  def mount(_params, _session, socket) do
    Explorer.Node.subscribe("tendermint/event/NewBlock")

    case get_txs_event(
           Explorer.Node.channel(),
           GetTxs.new(query: "message.sender EXISTS", order_by: OrderBy.value(:ORDER_BY_DESC))
         ) do
      {:ok, %{txs: txs}} ->
        {:ok, assign(socket, :txs, txs)}

      {:error, %GRPC.RPCError{message: message}} ->
        {:ok,
         socket
         |> put_flash(:error, message)
         |> assign(:txs, [])}
    end
  end

  def handle_info(%{block: %{data: %{txs: txs}} = x}, socket) do
    # TODO Decode tx and filter Vote Extensions
    {:noreply, assign(socket, :txs, Enum.concat(txs, socket.assigns.txs))}
  end
end
