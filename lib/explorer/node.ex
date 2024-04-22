defmodule Explorer.Node do
  use Kujira.Node,
    otp_app: :explorer,
    pubsub: Explorer.PubSub,
    subscriptions: ["tm.event='NewBlock'"]
end
