class ForecastService
  def self.get_coordinates(location)
    get_mapquest_data_url("/geocoding/v1/address", location: location)
  end

  def self.get_mapquest_data_url(url, params)
    response = mapquest_conn.get(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.mapquest_conn
    Faraday.new("http://www.mapquestapi.com") do |faraday|
      faraday.params["key"]=Rails.application.credentials.mapquest[:api_key]
    end
  end

  def self.get_weather(coord)
    params = {
      query: "#{coord[:lat]},#{coord[:lng]}",
      days: 5,
      aqi: "no",
      alerts: "no"
    }
    get_weather_data_url("/v1/forecast.json", params)
  end

  def self.get_weather_data_url(url, params)
    response = weather_conn.get(url, params)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def self.weather_conn
    Faraday.new("http://api.weatherapi.com") do |faraday|
      faraday.params["key"]=Rails.application.credentials.weather[:api_key]
    end
  end
end