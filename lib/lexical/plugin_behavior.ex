defmodule Lexical.PluginBehavior do
  @moduledoc false

  @callback init :: :ok

  @callback issues :: [term()]

  @callback issues(source :: String.t(), path: String.t()) :: [term()]
end
