require "selenium-webdriver"
require "pry"

PokemonSale = Struct.new(:date, :condition, :quantity, :price)
pokemon_sales = []

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument("--headless")
driver = Selenium::WebDriver.for :chrome, options: options

driver.navigate.to "https://www.tcgplayer.com/product/274461/Pokemon-Pokemon%20GO-Pikachu%2028?xid=adfe8e697-33fa-4146-8c9a-8d0208073684&Language=English" 
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


driver.quit