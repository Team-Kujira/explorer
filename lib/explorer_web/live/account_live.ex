defmodule ExplorerWeb.AccountLive do
  use ExplorerWeb, :live_view
  import Cosmos.Tx.V1beta1.Service.Stub
  import Cosmos.Auth.V1beta1.Query.Stub
  alias Cosmos.Auth.V1beta1.QueryAccountRequest, as: GetAccount
  alias Cosmos.Tx.V1beta1.GetTxsEventRequest, as: GetTxs
  alias Cosmos.Tx.V1beta1.OrderBy

  def mount(%{"address" => address}, _session, socket) do
    {:ok, %{account: account}} =
      account(Explorer.Node.channel(), GetAccount.new(address: address))

    account = Explorer.decode_any(account)

    case get_txs_event(
           Explorer.Node.channel(),
           GetTxs.new(
             query: "message.sender='#{address}'",
             order_by: OrderBy.value(:ORDER_BY_DESC)
           )
         ) do
      {:ok, %{txs: txs, tx_responses: tx_responses}} ->
        IO.inspect(tx_responses)

        {:ok,
         assign(socket, :txs, txs)
         |> assign(:address, address)
         |> assign(:account, account)
         |> assign(:tx_responses, tx_responses)}

      {:error, %GRPC.RPCError{message: message}} ->
        {:ok,
         socket
         |> put_flash(:error, message)
         |> assign(:address, address)
         |> assign(:account, account)
         |> assign(:txs, [])
         |> assign(:tx_responses, [])}
    end
  end

  def handle_info(%{block: %{data: %{txs: txs}} = x}, socket) do
    {:noreply, assign(socket, :txs, Enum.concat(txs, socket.assigns.txs))}
  end
end
