require "selenium-webdriver"
require "interactor"
require "pry"

class GetCardVariants
include Interactor
    CardVariant = Struct.new(:link, :set, :name) #look into rarity, market price, count, low
 
    def call
        while next_page_button_visible?(context.wait, context.driver) do
            create_cards(context.driver, context.wait)
            next_page_link(context.driver)
            next_page_button(context.driver)
        end
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
            # count = variant.find_element(:css, "span.inventory__listing-count.inventory__listing-count-block").text
            # low = variant.find_element(:css, "span.inventory__price").text
            # market = variant.find_element(:css, "span.search-result__market-price--value").text

            card_variant = CardVariant.new(link, set, name)
            card_variants << card_variant
        end
        print card_variants.count
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