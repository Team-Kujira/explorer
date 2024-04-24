defmodule ExplorerWeb.BlocksLive do
  use ExplorerWeb, :live_view
  alias Cosmos.Base.Tendermint
  import Tendermint.V1beta1.Service.Stub
  alias Tendermint.V1beta1.GetLatestBlockRequest, as: LatestBlock
  alias Tendermint.V1beta1.GetBlockByHeightRequest, as: Block

  def mount(_params, _session, socket) do
    Explorer.Node.subscribe("tendermint/event/NewBlock")
    blocks = get_blocks()
    {:ok, assign(socket, :blocks, blocks)}
  end

  def handle_info(%{block: %{header: %{height: height}}}, socket) do
    {:ok, %{block: block}} =
      get_block_by_height(
        Explorer.Node.channel(),
        Block.new(height: String.to_integer(height))
      )

    {:noreply, assign(socket, :blocks, Enum.take([block | socket.assigns.blocks], 20))}
  end

  def get_blocks() do
    with {:ok, %{block: block}} <- get_latest_block(Explorer.Node.channel(), LatestBlock.new()) do
      Range.new(1, 19)
      |> Enum.map(&(block.header.height - &1))
      |> Task.async_stream(&get_block_by_height(Explorer.Node.channel(), Block.new(height: &1)))
      |> Enum.reduce([block], fn
        {:ok, {:ok, %{block: block}}}, agg -> [block | agg]
        _, agg -> agg
      end)
      |> Enum.reverse()
    end
  end
end
