defmodule DealerReviewScraper do
  @moduledoc """
  DealerReviewScraper context

  All function to take a reviews from a dealer live here.
  """

  alias DealerReviewScraper.Review

  @base_url "https://www.dealerrater.com/dealer/McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews-23685"

  @doc """
    List top five most positives dealer reviews from McKaig-Chevrolet-Buick-A-Dealer-For-The-People-dealer-reviews
    in www.dealerrater.com parsed into a list of DealerReviewScraper.Review

    Examples

      iex> list_reviews("an_valid_dealer_url", amount_of_pages)
      {:ok, [DealerReviewScraper.Review.t()]}

      iex> list_reviews("an_invalid_dealer_url", amount_of_pages)
      {:error, :bad_request}
  """
  @spec list_reviews(binary(), integer()) :: {:ok, [Review.t()]} | {:error, :bad_request} | {:error, :undefined_error} | {:error, :invalid_url}
  def list_reviews(pages, base_url \\ nil) when is_nil(base_url) or byte_size(base_url) > 0 do
    base_url = base_url || @base_url

    base_url
    |> fetch_pages(pages)
    |> sort_reviews()
  end
  def list_reviews(_, ""), do: {:error, :invalid_url}

  defp fetch_pages(base_url, pages) do
    reviews =
      1..pages
      |> Task.async_stream(fn page ->
        with {:ok, body} <- fetch_page(base_url, page),
             {:ok, result} <- Review.parse_document(body) do
          result
        end
      end)
      |> Enum.map(fn {:ok, reviews} -> reviews end)
      |> Enum.concat()

    {:ok, reviews}
  rescue
    e in Protocol.UndefinedError ->
      e.value

    _ ->
      {:error, :undefined_error}
  end

  defp fetch_page(base_url, page) do
    url = "#{base_url}/page#{page}/?filter=ONLY_POSITIVE"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, body}

      _ ->
        {:error, :bad_request}
    end
  end

  defp sort_reviews({:error, error}), do: {:error, error}
  defp sort_reviews({:ok, reviews}) when is_list(reviews) do
    sorted_reviews =
      reviews
      |> Enum.filter(& &1.user_detailed_rating.recommend_dealer)
      |> Enum.sort_by(fn review ->
        {calculate_rating(review)}
      end,
      :desc)
      |> Enum.take(5)

    {:ok, sorted_reviews}
  end

  defp calculate_rating(%Review{} = review) when is_map(review) do
    rating =
      review.user_detailed_rating
      |> Map.values()
      |> Enum.filter(&is_integer/1)
      |> Enum.sum()
      |> Kernel.div(4)
  end
end
