defmodule DealerReviewScraper.ReviewTest do
  use ExUnit.Case, async: true

  import DealerReviewScraper.TestHelper

  alias DealerReviewScraper.Review

  setup do
    html = read_html!("dealerrater_page.html")

    {:ok, html: html}
  end

  describe "parse_document/1" do
    test "parse HTML body into list of reviews", %{html: html} do
      assert {:ok, reviews} = Review.parse_document(html)
      assert is_list(reviews)
      assert Enum.count(reviews) === 10
    end

    test "returns a error when given an empty HTML body" do
      assert {:error, :empty_body_detected} = Review.parse_document("")
    end
  end
end
