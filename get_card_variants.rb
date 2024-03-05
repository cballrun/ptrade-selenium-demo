require "selenium-webdriver"
require "interactor"
require "pry"

class GetCardVariants
include Interactor
    CardVariant = Struct.new(:link, :set, :name, :count, :low, :market) #look into rarity 
 
    def call
        create_cards(context.driver, context.wait)
    end

    private

    def find_variants(driver, wait)
        search_results = context.wait.until do
            context.driver.find_elements(:css, "div.search-result__content")
        end
    end

    def create_cards(driver, wait)
        card_variants = []
        variants = find_variants(driver, wait)
        variants.each do |variant|
            link = variant.find_element(:css, "a").attribute("href")
            set = variant.find_element(:css, "h4").text
            name = variant.find_element(:css, "span.search-result__title").text
            count = variant.find_element(:css, "span.inventory__listing-count.inventory__listing-count-block").text
            low = variant.find_element(:css, "span.inventory__price").text
            market = variant.find_element(:css, "span.search-result__market-price--value").text

            card_variant = CardVariant.new(link, set, name, count, low, market)
            card_variants << card_variant
        end
        card_variants
    end
end