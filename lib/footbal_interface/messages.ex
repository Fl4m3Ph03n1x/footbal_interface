defmodule FootbalInterface.Messages do
  use Protobuf, """
    syntax = "proto3";

    message Entry {
      string AwayTeam = 1;
      string Date = 2;
      string Div = 3;
      int32 FTAG = 4;
      int32 FTHG = 5;
      string FTR = 6;
      int32 HTAG = 7;
      int32 HTHG = 8;
      string HTR = 9;
      string HomeTeam = 10;
      int32 Season = 11;
    }

    message Response {
      repeated Entry results = 1;
    }
  """
end
