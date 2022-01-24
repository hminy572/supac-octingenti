defmodule SupacWeb.ChartLive do
  use SupacWeb, :live_view
  alias Supac.Sup
  require Logger

  @impl true
  def mount(_params, _, socket) do
    {:ok, socket
      |> assign(:slp, "")
      |> assign(:pc, Sup.pie_chart_leads())
      |> assign(:lc_path, Sup.line_path_leads())
      |> assign(:lc_circle, Sup.line_circle_leads())
      |> assign(:sample_lc, [
        [~N[2022-02-01 00:00:00], 11],
        [~N[2022-02-02 00:00:00], 22],
        [~N[2022-02-03 00:00:00], 33],
        [~N[2022-02-04 00:00:00], 44],
        [~N[2022-02-05 00:00:00], 55],
        [~N[2022-02-06 00:00:00], 66],
        [~N[2022-02-07 00:00:00], 77],
        [~N[2022-02-08 00:00:00], 88],
        [~N[2022-02-09 00:00:00], 99],
        [~N[2022-02-10 00:00:00], 12],
        [~N[2022-02-11 00:00:00], 13],
        [~N[2022-02-12 00:00:00], 23],
        [~N[2022-02-13 00:00:00], 34],
        [~N[2022-02-14 00:00:00], 45],
        [~N[2022-02-15 00:00:00], 56],
        [~N[2022-02-16 00:00:00], 67],
        [~N[2022-01-18 00:00:00], 59],
        [~N[2022-01-19 00:00:00], 43],
        [~N[2022-01-20 00:00:00], 42],
        [~N[2022-01-21 00:00:00], 78],
        [~N[2022-01-22 00:00:00], 94],
        [~N[2022-01-23 00:00:00], 82],
        [~N[2022-01-24 00:00:00], 51],
        [~N[2022-01-25 00:00:00], 14],
        [~N[2022-01-26 00:00:00], 69],
        [~N[2022-01-27 00:00:00], 70],
        [~N[2022-01-28 00:00:00], 50],
        [~N[2022-01-29 00:00:00], 30],
        [~N[2022-01-30 00:00:00], 20],
        [~N[2022-01-31 00:00:00], 0]
      ])
    }
  end

  @impl true
  def handle_event("sarah", _, socket) do
    Logger.info("sarah")
    {:noreply, socket |> assign(:slp, :sarah)}
  end

  def handle_event("tom", _, socket) do
    Logger.info("tom")
    {:noreply, socket |> assign(:slp, :tom)}
  end

  def handle_event("jane", _, socket) do
    Logger.info("jane")
    {:noreply, socket |> assign(:slp, :jane)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="mt-6 w-screen sm:w-11/12 md:w-10/12 lg:w-9/12 xl:w-8/12">
        <div class="m-4 p-4 border-4 border-amber-200 shadow-md">
          <svg
            id="chart"
            width="70%"
            height="100%"
            viewBox="-100 -30 1200 560"
            xmlns="http://www.w3.org/2000/svg"
          >
            <text
              fill="black"
              x="280"
              y="0"
              class="font-bold text-2xl"
            >
              日次のリード数
            </text>
            <path
              d={"M #{@lc_path} 930 500"}
              fill="none"
              stroke="#444cf7"
              stroke-width="5px"
            />
            <path d="M0 0 L0 500 M0 500 L1000 500 M0 0 L-30 0 M0 100 L-20 100 M0 200 L-20 200 M0 300 L-20 300 M0 400 L-20 400 M0 500 L-20 500" stroke="#ddd" fill="rgba(0,0,0,0)" stroke-width="5" />
            <g id="">
              <%= for d <- @lc_circle do %>
                <circle cx={Enum.at(d, 0)} cy={Enum.at(d, 1)} r="8" fill="#444cf7" />
              <% end %>
            </g>
          </svg>
        </div>
        <div class="m-4 p-4 border-4 border-amber-200 shadow-md">
          <p class="pie-chart-title">リードの各フェーズの割合</p>
          <figure
            class=""
            id="pie-chart"
            style={"background:
              radial-gradient(
                circle closest-side,
                transparent 66%,
                white 0
              ),
              conic-gradient(
                #4e79a7 0,
                #4e79a7 #{Enum.at(@pc, 0) * 100}%,
                #f28e2c 0,
                #f28e2c #{Enum.at(@pc, 0) * 100 + Enum.at(@pc, 1) * 100}%,
                #e15759 0,
                #e15759 #{Enum.at(@pc, 0) * 100 + Enum.at(@pc, 1) * 100 + Enum.at(@pc, 2) * 100}%,
                #76b7b2 0,
                #76b7b2 #{Enum.at(@pc, 0) * 100 + Enum.at(@pc, 1) * 100 + Enum.at(@pc, 2) * 100 + Enum.at(@pc, 3) * 100}%
              );
              "}
          >
            <figcaption>
              日程調整中<span style="color:#4e79a7"></span><br>
              案件化<span style="color:#f28e2c"></span><br>
              見込み<span style="color:#e15759"></span><br>
              連絡済み<span style="color:#76b7b2"></span>
            </figcaption>
          </figure>
        </div>
        <div class="m-4 p-4 border-4 border-amber-200 shadow-md">
          <svg
            width="100%"
            height="100%"
            viewBox="80 -40 700 350"
            version="1.1"
            xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink"
          >
            <g class="all-elements">
              <path
                class=""
                d="M159 50 L159 265 M250.2 50 L250.2 265 M341.4 50 L341.4 265 M432.6 50 L432.6 265 M523.8 50 L523.8 265 M615 50 L615 265"
                stroke="#ddd"
                fill="rgba(0,0,0,0)"
                stroke-width="1"
                shape-rendering="crispEdges"
                stroke-dasharray=""
                style="pointer-events: none"
              ></path>
              <text
                fill="black"
                x="280"
                y="0"
                class="font-bold text-2xl"
              >
                各セールスパーソンのリード数
              </text>
              <text x="100" y="25" fill="black">chosen sales person: <%= @slp %></text>
              <rect
                fill={if @slp == :sarah, do: "red", else: "orange"}
                x="159"
                y="60"
                width="308"
                height="23"
                style="cursor: pointer"
                phx-click="sarah"
              ></rect>

              <rect
                fill={if @slp == :tom, do: "red", else: "orange"}
                stroke="rgba(0,0,0,0)"
                fill="orange"
                x="159"
                y="131"
                width="258"
                height="23"
                style="cursor: pointer"
                phx-click="tom"
              ></rect>
              <rect
                fill={if @slp == :jane, do: "red", else: "orange"}
                stroke="rgba(0,0,0,0)"
                fill="orange"
                x="159"
                y="203"
                width="430"
                height="23"
                style="cursor: pointer"
                phx-click="jane"
              ></rect>

              <text
                tag="labels.xaxis"
                data-tag="labels.xaxis"
                fill="black"
                x="250.2"
                y="276"
                font-size="12pt"
                font-weight="normal"
                font-family="Arial, Verdana, sans-serif"
                font-style="normal"
                text-anchor="middle"
                dominant-baseline="hanging"
                style="pointer-events: none"
              >
                100
              </text>
              <text
                tag="labels.xaxis"
                data-tag="labels.xaxis"
                fill="black"
                x="341.4"
                y="276"
                font-size="12pt"
                font-weight="normal"
                font-family="Arial, Verdana, sans-serif"
                font-style="normal"
                text-anchor="middle"
                dominant-baseline="hanging"
                style="pointer-events: none"
              >
                200
              </text>
              <text
                tag="labels.xaxis"
                data-tag="labels.xaxis"
                fill="black"
                x="432"
                y="276"
                font-size="12pt"
                font-weight="normal"
                font-family="Arial, Verdana, sans-serif"
                font-style="normal"
                text-anchor="middle"
                dominant-baseline="hanging"
                style="pointer-events: none"
              >
                300
              </text>
              <text
                tag="labels.xaxis"
                data-tag="labels.xaxis"
                fill="black"
                x="523"
                y="276"
                font-size="12pt"
                font-weight="normal"
                font-family="Arial, Verdana, sans-serif"
                font-style="normal"
                text-anchor="middle"
                dominant-baseline="hanging"
                style="pointer-events: none"
              >
                400
              </text>
              <text
                tag="labels.xaxis"
                data-tag="labels.xaxis"
                fill="black"
                x="615"
                y="276"
                font-size="12pt"
                font-weight="normal"
                font-family="Arial, Verdana, sans-serif"
                font-style="normal"
                text-anchor="middle"
                dominant-baseline="hanging"
                style="pointer-events: none"
              >
                500
              </text>
              <text
                tag="labels.xaxis"
                data-tag="labels.xaxis"
                fill="black"
                x="159"
                y="275"
                font-size="12pt"
                font-weight="normal"
                font-family="Arial, Verdana, sans-serif"
                font-style="normal"
                text-anchor="middle"
                dominant-baseline="hanging"
                style="pointer-events: none"
              >
                0
              </text>
              <text
                tag="labels.yaxis"
                data-tag="labels.yaxis"
                fill="black"
                x="151"
                y="72"
                font-size="12pt"
                font-weight={if @slp == :sarah, do: "bold", else: ""}
                font-family="Arial, Verdana, sans-serif"
                font-style="normal"
                text-anchor="end"
                dominant-baseline="middle"
                style="pointer-events: none"
              >
                Sarah
              </text>
              <text
                tag="labels.yaxis"
                data-tag="labels.yaxis"
                fill="black"
                x="151"
                y="145"
                font-size="12pt"
                font-weight={if @slp == :tom, do: "bold", else: ""}
                font-family="Arial, Verdana, sans-serif"
                font-style="normal"
                text-anchor="end"
                dominant-baseline="middle"
                style="pointer-events: none"
              >
                Tom
              </text>
              <text
                tag="labels.yaxis"
                data-tag="labels.yaxis"
                fill="black"
                x="151"
                y="217"
                font-size="12pt"
                font-weight={if @slp == :jane, do: "bold", else: ""}
                font-family="Arial, Verdana, sans-serif"
                font-style="normal"
                text-anchor="end"
                dominant-baseline="middle"
                style="pointer-events: none"
              >
                Jane
              </text>
            </g>
          </svg>
        </div>
      </div>
    </div>
    """
  end
end
