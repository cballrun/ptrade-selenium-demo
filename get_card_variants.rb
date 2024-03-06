require "selenium-webdriver"
require "interactor"
require "csv"
require "pry"

class GetCardVariants
include Interactor
    CardVariant = Struct.new(:link, :set, :name, :rarity, :count, :low, :market, keyword_init: true)
 
    def call
        card_variants = []
        CSV.open("variants.csv", "wb", write_headers: true, headers: ["link", "set", "name", "rarity", "count", "low", "market"]) do |csv|
            while next_page_button_visible?(context.wait, context.driver) do
                create_cards(context.driver, context.wait, csv)
                next_page_link(context.driver)
                next_page_button(context.driver)
            end
        end
    end

    private

    def find_variants(driver, wait)
        search_results = context.wait.until do
            context.driver.find_elements(:css, "div.search-result__content")
        end
    end

    def safe_find_element(driver, css_selector)
        begin
            element = driver.find_element(css: css_selector)
        rescue Selenium::WebDriver::Error::NoSuchElementError
            element = nil
        end
        element
    end

    def create_cards(driver, wait, csv)
        card_variants = []
        variants = find_variants(driver, wait)
        variants.each do |variant|
          link = variant.find_element(:css, "a")&.attribute("href")
          set = safe_find_element(variant, "h4")&.text
          name = safe_find_element(variant, "span.search-result__title")&.text
          rarity = safe_find_element(variant, "section.search-result__rarity")&.text
          count = safe_find_element(variant, "span.inventory__listing-count.inventory__listing-count-block")&.text
          low = safe_find_element(variant, "span.inventory__price")&.text
          market = safe_find_element(variant, "span.search-result__market-price--value")&.text
      
          card_variant = CardVariant.new(link: link, set: set, name: name, rarity: rarity, count: count, low: low, market: market)
          csv << card_variant.to_a
        end
    end

    def next_page_button(driver)
        next_button = driver.find_elements(:css, "a.tcg-button.tcg-button--md.tcg-standard-button.tcg-standard-button--flat").last
    end

    def next_page_link(driver)
        pagination_buttons = driver.find_elements(:css, "a.tcg-button.tcg-button--md.tcg-standard-button.tcg-standard-button--flat")
        next_page_link = pagination_buttons.last.attribute("href")
        if next_page_link.class == String
            driver.get next_page_link
        else
            driver.quit
        end
    end

    def next_page_button_visible?(wait, driver)
        sleep 2
        wait.until { next_page_button(driver).displayed? }
    end
end