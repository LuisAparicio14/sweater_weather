require "rails_helper"

RSpec.describe RoadTrip do
  it "creates a road trip object" do
    json = File.read("spec/fixtures/road_trip/cincinnati_chicago.json")
    data = JSON.parse(json, symbolize_names: true)
    json_weather = File.read("spec/fixtures/road_trip/weather.json")
    weather = JSON.parse(json_weather, symbolize_names: true)

    road_trip = RoadTrip.new("Cincinnati, OH", "Chicago, IL", data, weather)

    expect(road_trip).to be_a(RoadTrip)
    expect(road_trip.start_city).to eq("Cincinnati, OH")
    expect(road_trip.end_city).to eq("Chicago, IL")
    expect(road_trip.travel_time).to eq("4 hrs, 20 min")
    expect(road_trip.weather_at_eta).to be_a(Hash)
    expect(road_trip.weather_at_eta[:datetime]).to eq("2024-04-24 05:00")
    expect(road_trip.weather_at_eta[:temperature]).to eq(38.2)
    expect(road_trip.weather_at_eta[:condition]).to eq("Patchy rain nearby")
  end
end