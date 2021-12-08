defmodule DealerReviewScraperTest do
  use ExUnit.Case, async: true

  import DealerReviewScraper.TestHelper

  alias DealerReviewScraper.Review

  describe "list_reviews/2" do
    test "list reviews from page when dealer exists" do
      page = 1
      bypass = dealer_http_server()

      assert {:ok, result} = DealerReviewScraper.list_reviews(page, bypass |> endpoint_url())

      assert is_list(result)
    end

    test "list reviews when url does not exists" do
      page = 1
      bypass = failing_dealer_http_server()

      assert {:error, :bad_request} = DealerReviewScraper.list_reviews(page, bypass |> endpoint_url())
    end

    test "list reviews when url is a empty string" do
      page = 1

      assert {:error, :invalid_url} = DealerReviewScraper.list_reviews(page, "")
    end
  end
end
