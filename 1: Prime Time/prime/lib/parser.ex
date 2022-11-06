defmodule Prime.Parser do
  def parse(json) do
    with {:ok, request} <- Prime.Parser.Request.from_json(json),
      response <- check(request) do
        Prime.Parser.Response.to_json(response)
      else
        _ -> "malformed"
      end
  end

  def check(request) do
    Prime.Parser.Response.from_request(request)
  end
end


defmodule Prime.Parser.Request do
  defstruct [:method, :number]

  def from_json(json) do
    case Jason.decode(json) do
      {:ok, map} -> from_map(map)
      {:error, _} -> {:error, json}
    end
  end

  def from_map(%{"method" => (method = "isPrime"), "number" => number}) when is_number(number) do
    {:ok, %__MODULE__{method: method, number: number}}
  end

  def from_map(map) do
    {:error, map}
  end
end


defmodule Prime.Parser.Response do
  defstruct [:method, :prime]

  def from_request(request) do
    %__MODULE__{method: request.method, prime: is_prime?(request.number)}
  end

  def to_json(response) do
    response
    |> Map.from_struct
    |> Jason.encode!
  end

  defp is_prime?(number) do
    is_prime?(number, number - 1)
  end

  defp is_prime?(number, i) do
    cond do
      number < 2 -> false
      i < 2 -> true
      true -> case rem(number, i) do
        0 -> false
        _ -> is_prime?(number, i - 1)
      end
    end
  end
end
