defmodule ExplorerWeb.BlocksView do
  use ExplorerWeb, :view

  def decode_tx(tx) do
    with {:ok, json} <- Jason.decode(tx) do
      json
    else
      {:error, _} ->
        %Cosmos.Tx.V1beta1.Tx{body: %{messages: messages} = body} = tx = Cosmos.Tx.V1beta1.Tx.decode(tx)
        %{tx | body: %{body | messages: Enum.map(messages, &Explorer.decode_any/1)}}
    end
  end
end
