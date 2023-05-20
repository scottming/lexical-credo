defmodule MyApp.Module1 do
  @moduledoc false
  def run(foo) do
    foo
  end
end

defmodule MyApp.Module2 do
  @moduledoc false
  def run(foo) do
    foo
  end
end

defmodule MyModule do
  @moduledoc false
  alias MyApp.Module2
  alias MyApp.Module1

  def my_function(foo) do
    # what the heck is `M1`?
    Module2.run(Module1.run(foo))
  end
end
