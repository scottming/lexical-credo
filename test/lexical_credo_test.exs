defmodule Lexical.CredoTest do
  use ExUnit.Case

  setup do
    Lexical.Credo.init()
  end

  test "no issues for current project because the .credo.ex works for project check" do
    assert Lexical.Credo.issues() == []
  end

  describe "Lexical.Credo.issues/2" do
    test "have issues for a file that included by .credo.exs" do
      [issue] = Lexical.Credo.issues(~s[IO.puts("hello world");\n], "lib/lexical_credo.ex")
      assert issue.filename == "lib/lexical_credo.ex"
      assert issue.message == "Don't use ; to separate statements and expressions"
    end

    test "no issues for a file that execluded by .credo.exs" do
      assert [] =
               Lexical.Credo.issues(
                 ~s[IO.puts("hello world");\n],
                 "lib/examples/execluded/alias_as.ex"
               )
    end

    test "no issues with Module_Name because we disabled it in `.credo.exs` file" do
      source = ~s[defmodule Module_Name do\nend\n]
      assert [] = Lexical.Credo.issues(source, "lib/alias.ex")
    end
  end
end
