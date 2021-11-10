+++
date = "2016-11-09T08:57:28-05:00"
title = "Elixir ExUnit.DocTest"
tags = [ "elixir", "testing" ]

aliases = ["elixir-doctests"]

+++

Have you ever been frustrated by the lack working examples in documentation? [Elixir](http://elixir-lang.org/) helps solve this problem with a built in feature called DocTest.

<!--more-->

Elixir's testing framework ExUnit provides built in support for a feature called [DocTest](http://elixir-lang.org/docs/stable/ex_unit/ExUnit.DocTest.html) which allows you to write test cases in the documentation block for a function. This works really well for pure functions that simply take data and return data but is not advised for any functions that have side effects. 

```
defmodule Calculator do
  @doc """
  Adds two numbers and returns the result.

  ## Examples
      iex> Calculator.add(1, 2)
      3

      iex> Calculator.add(5, 5)
      10
  """
  def add(a, b) do
    a + b
  end

  @doc """
  Subtracts two numbers and returns the result.

  ## Examples
      iex> Calculator.subtract(1, 2)
      -1

      iex> Calculator.subtract(5, 5)
      0
  """
  def subtract(a, b) do
    a - b
  end
end
```

When you run the test suite, ExUnit will look for these tests then run and verify the results just like if you had written a standard unit test in a specific test module. Now the documentation for the module includes these examples making it really easy for someone to see how the function works without having to dig into the test code or use trial and error to figure out how it works.

```markdown
iex> h Calculator.add

                                 def add(a, b)

Adds two numbers and returns the result.

Examples

┃ iex> Calculator.add(1, 2)
┃ 3
┃
┃ iex> Calculator.add(5, 5)
┃ 10
```

The [Elixir School](https://elixirschool.com/lessons/basics/documentation/#documenting-functions) also provides some great information on function documentation and the features that Elixir provides.
