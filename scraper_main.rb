require "selenium-webdriver"
require "interactor"
require_relative "scraping_organizer"
require "pry"

class ScraperMain
    
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless")
    
    def initialize
        @options = Selenium::WebDriver::Chrome::Options.new
                    @options.add_argument("--headless")
        @driver = Selenium::WebDriver.for :chrome, options: @options
        @search_str = "blastoise"
        @driver.get "https://www.tcgplayer.com/"
        @wait = Selenium::WebDriver::Wait.new(timeout: 10)
    end

    def scrape
        ScrapingOrganizer.call(
            driver: @driver,
            wait: @wait,
            search_str: @search_str
        )
        binding.pry
        @driver.quit
    end
end

ScraperMain.new.scrape