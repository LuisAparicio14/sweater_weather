class RoadTripService
  def self.time_and_coordinates(origin, destination)
    post_mapquest_data_url("/directions/v2/routematrix", { locations: [origin, destination] }.to_json)
  end

  def self.post_mapquest_data_url(url, body)
    response = map_quest_conn.post(url, body)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.map_quest_conn
    Faraday.new(url: "http://www.mapquestapi.com") do |faraday|
      faraday.params["key"] = Rails.application.credentials.map_quest[:key]
    end
  end

  def self.get_road_trip_weather(coord, time)
    params = {
      query: "#{coord[:lat]},#{coord[:lng]}",
      days: 1,
      dt: "#{time[:date]}",
      hour: "#{time[:hour]}",
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
    Faraday.new(url: "http://api.weatherapi.com") do |faraday|
      faraday.params["key"] = Rails.application.credentials.weather[:key]
    end
  end
end