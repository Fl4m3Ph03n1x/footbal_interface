defmodule FootbalInterface.FormatterTest do
  use ExUnit.Case

  alias FootbalInterface.Formatter

  describe "/format" do
    test "encodes to JSON" do
      data = %{
        "AwayTeam"  => "Barcelona",
        "Season"    =>  201_213
      }

      {:ok, _resp} = Formatter.format(data, "json")
    end

    test "returns error if JSON encoding fails" do
      data = {:status, 0}

      {:error, :json_encoding_failed, _err} = Formatter.format(data, "json")
    end

    test "encodes to Protobuf" do
      data = [%{
        "AwayTeam"  => "Eibar",
        "Date"      => "2016-08-19",
        "Div"       => "SP9",
        "FTAG"      => 1,
        "FTHG"      => 2,
        "FTR"       => "H",
        "HTAG"      => 0,
        "HTHG"      => 0,
        "HTR"       => "D",
        "HomeTeam"  => "La Coruna",
        "Season"    => 201617
      }]

      {:ok, _res} = Formatter.format(data, "protobuff")
    end

    test "returns error if Protobuf encoding fails" do
      data = [%{
        "AwayTeam"  => "Eibar",
        "Season"    => "bad_season"
      }]

      {:error, :protobuff_encoding_failed, _res} = Formatter.format(data, "protobuff")
    end

    test "returns error if format is not recognized" do
      data = %{}
      bad_format = "bananas"

      actual = Formatter.format(data, bad_format)
      expected = {:error, :invalid_format, bad_format}

      assert actual === expected
    end
  end

end
