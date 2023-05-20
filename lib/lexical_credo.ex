defmodule Lexical.Credo do
  @moduledoc false

  @behaviour Lexical.PluginBehavior

  @impl true
  def init do
    {:ok, _} = Application.ensure_all_started(:credo)
    GenServer.call(Credo.CLI.Output.Shell, {:suppress_output, true})
    :ok
  end

  @impl true
  def issues do
    Credo.Execution.build()
    |> Credo.Execution.run()
    |> Credo.Execution.get_issues()
  end

  @impl true
  def issues(source, file) do
    original_gl = Process.group_leader()
    {:ok, gl} = StringIO.open(source, capture_prompt: true)

    try do
      Process.group_leader(self(), gl)
      exec = Credo.Execution.build(["--mute-exit-status", "--read-from-stdin", file])
      {:ok, %{files: %{excluded: excluded}}} = Credo.ConfigFile.read_or_default(exec, ".")

      if Enum.any?(excluded, &String.match?(file, &1)) do
        []
      else
        exec
        |> Credo.Execution.run()
        |> Credo.Execution.get_issues()
      end
    after
      Process.group_leader(self(), original_gl)
    end
  end
end
