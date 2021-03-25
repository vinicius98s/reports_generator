defmodule ReportsGenerator do
  alias ReportsGenerator.ReportBuilder

  def build(filename) do
    filename
    |> parse_file()
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(report_acc(), &ReportBuilder.build_report/2)
  end

  defp parse_file(filename) do
    "reports/#{filename}"
    |> File.stream!()
  end

  defp parse_line(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> format_line_to_map()
  end

  defp format_line_to_map([name, hours, _day, month, year]) do
    %{
      "name" => name,
      "hours" => String.to_integer(hours),
      "month" => month_name(month),
      "year" => year
    }
  end

  defp report_acc() do
    %{"all_hours" => %{}, "hours_per_month" => %{}, "hours_per_year" => %{}}
  end

  defp month_name("1"), do: "janeiro"
  defp month_name("2"), do: "fevereiro"
  defp month_name("3"), do: "março"
  defp month_name("4"), do: "abril"
  defp month_name("5"), do: "maio"
  defp month_name("6"), do: "junho"
  defp month_name("7"), do: "julho"
  defp month_name("8"), do: "agosto"
  defp month_name("9"), do: "setembro"
  defp month_name("10"), do: "outubro"
  defp month_name("11"), do: "novembro"
  defp month_name("12"), do: "dezembro"
end
