require "rails_helper"

RSpec.describe RoadTripService do
  it "returns locations data between two cities" do
    json_response = File.read("spec/fixtures/road_trip/cincinnati_chicago.json")
    stub_request(:post, "http://www.mapquestapi.com/directions/v2/routematrix").
      with( query: { key: Rails.application.credentials.map_quest[:key] }).
      to_return(status: 200, body: json_response)
    
    data_route = RoadTripService.time_and_coordinates("Cincinnati, OH", "Chicago, IL")

    expect(data_route).to be_a(Hash)
    expect(data_route[:time]).to be_a(Array)
    expect(data_route[:locations]).to be_a(Array)
    expect(data_route[:locations]).to all(include(:adminArea5, :adminArea3))
    expect(data_route[:locations][1][:latLng]).to include(:lat, :lng)
  end

  it "returns weather data between two cities" do
    coordinates = {lat: 41.88425, lng: -87.63245}
    time = {date: "2024-04-24", hour: 5}
    json_response = File.read("spec/fixtures/road_trip/weather.json")
    stub_request(:get, "https://api.weatherapi.com/v1/forecast.json").
      with(
        query: {
            key: Rails.application.credentials.weather[:key],
            q: "#{coordinates[:lat]},#{coordinates[:lng]}",
            days: 1,
            dt: time[:date],
            hour: time[:hour],
            aqi: "no",
            alerts: "no"
          }
        ).
      to_return(status: 200, body: json_response)
    # require 'pry' ; binding.pry
    parsed_json = RoadTripService.weather_at_arrival(coordinates, time)
    expect(parsed_json).to be_a(Hash)

    weather = parsed_json[:forecast][:forecastday]
    expect(weather.size).to eq(1)
    expect(weather[0][:hour].size).to eq(1)
    expect(weather[0][:hour][0]).to include(:time, :temp_f, :condition)
    expect(weather[0][:hour][0][:condition]).to include(:text)
  end
end