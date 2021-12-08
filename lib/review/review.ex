defmodule DealerReviewScraper.Review do
  @moduledoc """
    Review context

    All function used to parse data from HTML into a Review.t() is live here.
  """

  defstruct title: nil,
            date: nil,
            user: nil,
            user_comment: nil,
            user_overall_rating: nil,
            user_detailed_rating: nil

  @typedoc "A review"
  @type t() :: %__MODULE__{
    title: String.t() | nil,
    date: String.t() | nil,
    user: String.t() | nil,
    user_comment: String.t() | nil,
    user_overall_rating: integer() | nil,
    user_detailed_rating: map() | nil
  }

  @doc """
  Receives a body that is a HTML extracted from page and extract review from each user and return
  list of Review.t()

  iex> parse_document(body)
  {:ok, [Review.t()]}

  iex> parse_document("")
  {:error, :empty_body_detected}
  """
  @spec parse_document(binary()) :: {:ok, [Review.t()]} | {:error, :empty_body_detected}
  def parse_document(body) do
    body
    |> Floki.parse_document!()
    |> find_reviews()
  end

  defp find_reviews(document) do
    case Floki.find(document, ".review-entry") do
      [] ->
        {:error, :empty_body_detected}

      reviews ->
        result = Enum.map(reviews, &parse_review/1)

        {:ok, result}
    end
  end

  defp parse_review(review) do
    %__MODULE__{
      title: parse_title(review),
      date: parse_date(review),
      user: parse_user(review),
      user_comment: parse_user_comment(review),
      user_overall_rating: parse_user_rating(review),
      user_detailed_rating: parse_user_detailed_rating(review)
    }
  end

  defp parse_title(review) do
    review
    |> Floki.find(".review-title")
    |> Floki.text()
    |> String.replace("\"", "")
  end

  defp parse_date(review) do
    review
    |> Floki.find(".review-date div:first-child")
    |> Floki.text()
  end

  defp parse_user(review) do
    review
    |> Floki.find(".review-wrapper span.notranslate")
    |> Floki.text()
    |> String.replace("by ", "")
  end

  defp parse_user_comment(review) do
    review
    |> Floki.find(".review-whole")
    |> Floki.text()
    |> String.replace(["\"", "\n", "\r"], "")
    |> String.trim()
  end

  defp parse_user_rating(review) do
    review
    |> Floki.find(".dealership-rating .rating-static:first-child")
    |> Floki.attribute("class")
    |> List.first()
    |> String.split()
    |> extracting_ratings()
  end

  defp parse_user_detailed_rating(review) do
    [recommend | rating_remain] =
      review
      |> Floki.find(".review-ratings-all .table .tr")
      |> Enum.reverse()

    rating_remain
    |> Enum.map(fn data ->
      name = parse_user_detailed_rating_name(data)
      value = parse_user_detailed_rating_value(data)

      {name, value}
    end)
    |> Map.new()
    |> Map.put(:recommend_dealer, parse_user_detailed_rating_recommend(recommend))
  end

  defp parse_user_detailed_rating_name(data) do
    data
    |> Floki.find("div.small-text")
    |> Floki.text()
    |> String.downcase()
    |> String.replace(" ", "_")
    |> String.to_atom()
  end

  defp parse_user_detailed_rating_value(data) do
    data
    |> Floki.find("div.rating-static-indv")
    |> Floki.attribute("class")
    |> List.first()
    |> String.split()
    |> extracting_ratings()
  end

  defp parse_user_detailed_rating_recommend(recommend) do
    recommend
    |> Floki.text()
    |> String.upcase()
    |> String.contains?("YES")
  end

  defp extracting_ratings(ratings) when is_list(ratings) do
    ratings
    |> Enum.map(&extracting_rating/1)
    |> Enum.reject(&is_atom/1)
  end
  defp extracting_ratings(_), do: :error

  defp extracting_rating(<<"rating-", rating::binary-size(2)>>), do: String.to_integer(rating)
  defp extracting_rating(_), do: :none
end
