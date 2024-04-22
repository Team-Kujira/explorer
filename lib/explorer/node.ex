defmodule Explorer.Node do
  use Kujira.Node,
    otp_app: :my_app,
    pubsub: Explorer.PubSub,
    subscriptions: ["tm.event='NewBlock'"]
end
