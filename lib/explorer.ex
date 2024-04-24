defmodule Explorer do
  @moduledoc """
  Explorer keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def decode_any(%Google.Protobuf.Any{
    type_url: type_url,
    value: value
  }) do
    module = to_module(type_url)
    module.decode(value)
  end

  def to_module("/" <> type_url) do
    parts = type_url
      |> String.split( ".")
      |> Enum.map(&capitalize/1)
      |> Enum.join(".")

    String.to_existing_atom("Elixir." <> parts)
  end

  def capitalize(string) do
    with <<c :: utf8, rest :: binary>> <- string,
      do: String.upcase(<<c>>) <> rest
  end

  def tx_hash(bytes) do
    Base.encode16(:crypto.hash(:sha256, bytes))
  end
end
