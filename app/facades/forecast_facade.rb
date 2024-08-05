class ForecastFacade
  def self.get_coordinates(location)
    data = ForecastService.get_coordinates(location)
    # require 'pry' ; binding.pry
    coord = data[:results].first[:locations].first[:latLng]
  end

  def self.get_weather(coord)
    data = ForecastService.get_weather(coord)
    Forecast.new(data)
  end
end 