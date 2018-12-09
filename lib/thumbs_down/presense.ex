defmodule ThumbsDown.Presence do
    use Phoenix.Presence, otp_app: :thumbs_down,
                          pubsub_server: ThumbsDown.PubSub
  end