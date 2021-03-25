defmodule ReportsGenerator.ReportBuilder do
  def build_report(hour_report, report) do
    {updated_report, _hour_report} =
      {report, hour_report}
      |> update_report("all_hours")
      |> update_report("hours_per_month")
      |> update_report("hours_per_year")

    updated_report
  end

  defp update_report({report, %{"hours" => hours, "name" => name} = hour_report}, "all_hours") do
    updated_report = Map.update!(report, "all_hours", &sum_report_hours(&1, name, hours))

    {updated_report, hour_report}
  end

  defp update_report({report, hour_report}, "hours_per_month") do
    updated_report =
      Map.update!(report, "hours_per_month", &update_report_key(&1, hour_report, "month"))

    {updated_report, hour_report}
  end

  defp update_report({report, hour_report}, "hours_per_year") do
    updated_report =
      Map.update!(report, "hours_per_year", &update_report_key(&1, hour_report, "year"))

    {updated_report, hour_report}
  end

  defp update_report_key(prev_map, hour_report, key) when key == "month" or key == "year" do
    Map.update(
      prev_map,
      hour_report["name"],
      %{},
      &sum_report_hours(&1, hour_report[key], hour_report["hours"])
    )
  end

  defp sum_report_hours(previous_map, key, hours) do
    Map.update(previous_map, key, 0, fn prev_hours ->
      prev_hours + hours
    end)
  end
end
