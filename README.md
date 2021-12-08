# DealerReviewScraper

This lib fetches reviews from dealerrater.com and sorts five most positive reviews

Criteria used to take five most positive reviews:
- Filter by ONLY_POSITIVE reviews;
- Average from these four ratings, where each one of this rating can have max 5 stars:
  - Customer Service
  - Friendliness
  - Pricing
  - Overall Experience

## Installation
- Clone the repo: `git clone https://github.com/AchilesGomes/dealer_review_scrapper.git`
- Install deps: `cd dealer_review_scrapper && mix deps.get`
- Run tests: `mix test`
- If you want just: `iex -S mix` and let`s rock!
  - Inside of iex, just enter with:
  ```
  DealerReviewScraper.list_reviews(amount_of_pages, url)
  DealerReviewScraper.list_reviews(1, "https://www.dealerrater.com/dealer/Joe-Bullard-Acura-review-36326")
  ```
  - This should returns five most positivies reviews from first page of **Joe-Bullard-Acura**
  - By default you can use like this:
  ```
  DealerReviewScraper.list_reviews 1
  ```
  - This should return five most positives reviews from first page of "McKaig-Chevrolet-Buick-A-Dealer-For-The-People"
