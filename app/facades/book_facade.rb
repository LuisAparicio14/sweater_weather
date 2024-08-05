class BookFacade
  def self.get_books(location, quantity)
    books = BookService.get_books_for(location)
    coord = ForecastFacade.get_coordinates(location)
    forecast = ForecastFacade.get_weather(coord)
    current_weather = {condition: forecast.current_weather[:condition], temp: forecast.current_weather[:temperature]}
    Book.new(books, current_weather, quantity)
  end
end