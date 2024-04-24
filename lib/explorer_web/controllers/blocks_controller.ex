defmodule ExplorerWeb.BlocksController do
  use ExplorerWeb, :controller
  import Cosmos.Base.Tendermint.V1beta1.Service.Stub
  alias Cosmos.Base.Tendermint.V1beta1.GetBlockByHeightRequest, as: GetBlock
  alias Cosmos.Base.Tendermint.V1beta1.Block

  action_fallback ExplorerWeb.FallbackController


  def show(conn, %{"height" => height}) do
    with {height, ""} <- Integer.parse(height),
         {:ok, %{block: block}} <- get_block_by_height(Explorer.Node.channel(), GetBlock.new(height: height)) do
      conn = conn |> assign(:block, block)
      render(conn, "show.html")
    end
  end
end
