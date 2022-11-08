defmodule Prime.Parser.Test do
  use ExUnit.Case

  test "parse well formed json" do
    %{"method" => "isPrime", "number" => 123}
    |> Jason.encode!
    |> Prime.Parser.parse
  end

  test "prime numbers" do
    numbers = [2, 3, 5, 7, 11]

    for n <- numbers do
      response =
        %Prime.Parser.Request{method: "isPrime", number: n}
        |> Prime.Parser.check
      assert response == %Prime.Parser.Response{method: "isPrime", prime: true}, "#{n}"
    end
  end

  test "nonprime numbers" do
    numbers = [0, 1, 4, 6, 8, 9, 10]

    for n <- numbers do
      response =
        %Prime.Parser.Request{method: "isPrime", number: n}
        |> Prime.Parser.check
      assert response == %Prime.Parser.Response{method: "isPrime", prime: false}, "#{n}"
    end
  end
end
