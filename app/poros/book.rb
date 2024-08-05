class Book
  attr_reader :id, :destination, :forecast, :total_books_found, :books

  def initialize(results_for_books, current_weather, quantity)
    @id = nil
    @destination = formated_destination(results_for_books[:q])
    @forecast = formated_weather(current_weather)
    @total_books_found = results_for_books[:numFound]
    @books = formated_books(results_for_books, quantity)
  end

  def formated_destination(location)
    city = location.split(",").first.capitalize
    state = location.split(",").last.upcase
    "#{city}, #{state}"
  end

  def formated_weather(weather)
    {
    summary: weather[:condition],
    temperature: "#{weather[:temp].to_i} F"
    }
  end

  def formated_books(results_for_books, quantity)
    books = []
    results = results_for_books[:docs].take(quantity.to_i)
    
    results.each do |book_result|
      book = {}
      book[:isbn] = book_result[:isbn]
      book[:title] = book_result[:title]
      book[:publisher] = book_result[:publisher]
      books << book
    end
    books
  end
end