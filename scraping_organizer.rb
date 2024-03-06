require "selenium-webdriver"
require "interactor"
require_relative "search_card"
require_relative "get_card_variants"


class ScrapingOrganizer
    include Interactor::Organizer

    organize SearchCard, GetCardVariants
end