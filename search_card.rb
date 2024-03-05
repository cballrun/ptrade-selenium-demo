require "selenium-webdriver"
require "interactor"
require "pry"

class SearchCard
    include Interactor

    def call
        fill_form(context.driver, context.wait, context.search_str)
        submit_form(context.driver, context.wait)
        sleep 2
    end

    private

    def fill_form(driver, wait, search_str)
        search_input = wait.until do
            driver.find_element(:css, "input")
        end
        search_input.send_keys search_str
    end

    def submit_form(driver, wait)
        submit_button = wait.until do
            driver.find_element(:css, "button.button.search-bar__spyglass")
        end
        submit_button.click
    end
end