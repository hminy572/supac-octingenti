defmodule SupacWeb.ChartLive do
  use SupacWeb, :live_view

  alias Contex.{
    BarChart,
    PieChart,
    LinePlot,
    Plot,
    Dataset,
    ContinuousLinearScale,
    Scale
  }
  require Logger
  alias Supac.Sup

  @impl true
  def mount(_params, _, socket) do
    { :ok, socket |> make_bar() |> make_pie() |> make_line()}
  end

  defp make_bar(socket) do
    # in case no data
    data =
      if Sup.bar_chart_leads() == [] do
        [
          {"100~300", 0},
          {"1~5", 0},
          {"300~", 0},
          {"30~50", 0},
          {"50~100", 0},
          {"5~30", 0}
        ]
      else
        Sup.bar_chart_leads()
      end

    assign(socket,
      bar_svg: Plot.new(
        Dataset.new(
          data,
          ["size", "frequency"]
        ),
        BarChart,
        600,
        300,
        [
          mapping: %{category_col: "size", value_cols: ["frequency"]},
          legend_setting: :legend_right,
          title: "Company Size Frequency in Leads",
          data_labels: false,
          type: :stacked
        ]
      )
        |> Plot.axis_labels("size", "frequency")
        |> Plot.to_svg()
    )
  end

  defp make_line(socket) do
    # in case no data
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    plot = Sup.line_plot_leads()

    data =
    if Sup.list_leads == [] do
      [{now, 0}]
    else
      plot
    end

    # ************ IMPORTANT ************
    # About data type of LinePlot TimeScale
    # DateTime and NaiveDateTime -> works fine
    # Date and Time -> does not work
    # ************ IMPORTANT ************

    # force y scale to be 0 ~ 5
    y_scale = ContinuousLinearScale.new() |> ContinuousLinearScale.domain(0, 30) |> Scale.set_range(0, 30)

    assign(socket,
      line_svg: Plot.new(
              Dataset.new(
                data,
                ["Size", "freq"]
              ),
              LinePlot,
              700,
              300,
              [
                mapping: %{x_col: "Size", y_cols: ["freq"]},
                smoothed: false,
                legend_setting: :legend_right,
                title: "Number of Leads per date",
                type: "line",
                colour_scheme: "default",
                custom_y_scale: y_scale
              ]
            )
            |> Plot.axis_labels("Date", "number of Leads")
            |> Plot.to_svg()
    )
  end

  defp make_pie(socket) do
    # in case no data
    data =
    if Sup.pie_chart_leads() == [] do
      [
        {"no data", 100}
      ]
    else
      Sup.pie_chart_leads()
    end

    assign(socket, pie_svg:
      Plot.new(
        Dataset.new(
          data,
          ["cat", "1"]),
          PieChart,
          700,
          400,
          [
            mapping: %{category_col: "cat", value_col: "1"},
            legend_setting: :legend_right,
            title: "Lead State Chart",
            data_labels: true,
            #colour_palette: ["ff9838", "fdae53", "fbc26f", "fad48e", "fbe5af", "fff5d1"] # orange gradient
          ]
      )
      |> Plot.to_svg()
    )
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="mt-6 w-screen sm:w-11/12 md:w-10/12 lg:w-9/12 xl:w-8/12">
        <div class="m-4 p-4 border-4 border-amber-200 shadow-md"><%= @bar_svg %></div>
        <div class="m-4 p-4 border-4 border-amber-200 shadow-md"><%= @line_svg %></div>
        <div class="m-4 p-4 border-4 border-amber-200 shadow-md"><%= @pie_svg %></div>
      </div>
    </div>
    """
  end
end
