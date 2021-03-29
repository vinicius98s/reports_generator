defmodule ReportsGenerator do
  alias ReportsGenerator.ReportBuilder
  alias ReportsGenerator.Parser

  def build(filename) when not is_bitstring(filename), do: {:error, "Please provide a file name"}

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), &ReportBuilder.build_report/2)
  end

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "Please provide a list of file names"}
  end

  def build_from_many(filenames) do
    result =
      filenames
      |> Task.async_stream(&build/1)
      |> Enum.reduce(report_acc(), fn {:ok, result}, report ->
        ReportBuilder.merge_reports(report, result)
      end)

    {:ok, result}
  end

  defp report_acc() do
    %{"all_hours" => %{}, "hours_per_month" => %{}, "hours_per_year" => %{}}
  end
end
