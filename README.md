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
  DealerReviewScraper.list_reviews 1
  ```
  first param = amount of pages
  second param = dealer url
  - This should return five most positives reviews from "McKaig-Chevrolet-Buick-A-Dealer-For-The-People"
  - If you want to try a different dealer:
    ```
    DealerReviewScraper.list_reviews 2, "https://www.dealerrater.com/dealer/Joe-Bullard-Acura-review-36326"
    ```
