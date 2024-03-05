require "selenium-webdriver"
require "interactor"
require_relative "search_card"


class ScrapingOrganizer
    include Interactor::Organizer

    organize SearchCard
end