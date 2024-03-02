require "selenium-webdriver"
require "pry"
require "csv"

PokemonSale = Struct.new(:date, :condition, :quantity, :price)
pokemon_sales = []

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument("--headless")
driver = Selenium::WebDriver.for :chrome, options: options

driver.navigate.to "https://www.tcgplayer.com/product/527885/pokemon-trading-card-game-classic-venusaur?xid=pi632ed4eb-830d-4d03-9d3f-c0e8baa9fd90&page=1&Language=English" 
driver.manage.timeouts.implicit_wait = 10

latest_sales = driver.find_element(:css, "section.latest-sales") #pulls 3 most recent sales, try latest_sales.text


view_more = driver.find_element(:css, "h3.price-guide__more") #working
view_more_data = driver.find_element(:css, "div.modal__activator") #working

view_more_data.click

driver.manage.timeouts.implicit_wait = 10


sales_history_snapshot_2 = driver.find_element(:css, "ul.is-modal")
sales_list = sales_history_snapshot_2.find_elements(:css, "li")

sales_list.each do |sale|
    date = sale.find_element(:css, "span.date").text
    condition = sale.find_element(:css, "span.condition").text
    quantity = sale.find_element(:css, "span.quantity").text
    price = sale.find_element(:css, "span.price").text

    pokemon_sale = PokemonSale.new(date, condition, quantity, price)
    pokemon_sales << pokemon_sale 
end

csv_headers = ["date", "condition", "quantity", "price"]
CSV.open("output.csv", "wb", write_headers: true, headers: csv_headers) do |csv|
    pokemon_sales.each do |pokemon_sale|
        csv << pokemon_sale
    end
end


driver.quit