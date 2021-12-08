defmodule DealerReviewScraper.TestHelper do
  @moduledoc """
    Functions to helper in setup for tests
  """

  @doc """
    Reads dealerrater reviews page
  """
  def read_html!(filename) do
    File.read!("test/assets/#{filename}")
  end

  @doc """
    A http_server mock that returns 200
  """
  def dealer_http_server do
    bypass = Bypass.open()

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, read_html!("dealerrater_page.html"))
    end)

    bypass
  end

  @doc """
    A http_server mock that returns 500
  """
  def failing_dealer_http_server do
    bypass = Bypass.open()

    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 500, "")
    end)

    bypass
  end

  @doc """
    Receives a bypass and returns a url base to be used in `ReviewTest`
  """
  def endpoint_url(bypass), do: "http://localhost:#{bypass.port}/"
end
