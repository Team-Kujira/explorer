defmodule ExplorerWeb.TxsView do
  alias Cosmos.Tx.V1beta1.Tx
  use ExplorerWeb, :view

  @spec message_tag(Cosmos.Tx.V1beta1.Tx.t()) :: String.t()
  def message_tag(%Tx{body: %{messages: [message | rest]}}) do
    [label | _] = String.split(message.type_url, ".") |> Enum.reverse()

    case Enum.count(rest) do
      0 -> label
      x -> "#{label} +#{x}"
    end
  end
end
