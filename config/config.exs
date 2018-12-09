# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :thumbs_down,
  ecto_repos: [ThumbsDown.Repo]

# Configures the endpoint
config :thumbs_down, ThumbsDownWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6QpwMFW+iX0L8pVkoT9Q/OE9xRXTCBsT8dw/p06/x8EXLG06OjcNF1BuSkQBnAFb",
  render_errors: [view: ThumbsDownWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ThumbsDown.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
