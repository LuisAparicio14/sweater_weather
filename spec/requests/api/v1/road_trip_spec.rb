require "rails_helper"

RSpec.describe "POST /api/v1/road_trip" do
  let!(:user) { User.create!(email: "luis@email.com", password: "most_secure_password", password_confirmation: "most_secure_password", api_key: "ea2f6e7441fab8aa96f1611a0361c60d") }

  before do
    json_response_1 = File.read("spec/fixtures/road_trip/cincinnati_chicago.json")
    stub_request(:post, "http://www.mapquestapi.com/directions/v2/routematrix?key=#{Rails.application.credentials.map_quest[:key]}").
      with(
        body: "{\"locations\":[\"Cincinatti,OH\",\"Chicago,IL\"]}",
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: json_response_1, headers: {})
    
    allow(Time).to receive(:now).and_return(Time.parse("2024-04-24 02:22:40.541249 -0500"))
    coordinates = {lat: 41.88425, lng: -87.63245}
    date = "2024-04-24"
    hour = 7
    json_response_2 = File.read("spec/fixtures/road_trip/weather.json")
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?alerts=no&aqi=no&days=1&dt=2024-04-24&hour=7&key=#{Rails.application.credentials.weather[:key]}&query=41.88425,-87.63245").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: json_response_2, headers: {})
  end

  it "returns roat trip details with weather(happy path)" do
    headers = { "Content_Type": "application/json", "Accept": "application/json" }
    body = { "origin": "Cincinatti,OH", "destination": "Chicago,IL", "api_key": user.api_key }

    post "/api/v1/road_trip", params: body, headers: headers

    expect(response).to be_successful
    expect(response.status).to eq(201)

    road_trip = JSON.parse(response.body, symbolize_names: true)[:data]
    trip_details = road_trip[:attributes]

    expect(road_trip[:id]).to eq(nil)
    expect(road_trip[:type]).to eq("road_trip")
    expect(trip_details).to include(:start_city, :end_city, :travel_time, :weather_at_eta)
    expect(trip_details[:weather_at_eta]).to include(:datetime, :temperature, :condition)
  end

  it "returns unauthorized if api_key is invalid(sad path)" do
    headers = { "Content_Type": "application/json", "Accept": "application/json" }
    wrong_api = { "origin": "Cincinatti,OH", "destination": "Chicago,IL", "api_key": "incorrect" }
    blank_api = { "origin": "Cincinatti,OH", "destination": "Chicago,IL", "api_key": "" }

    post "/api/v1/road_trip", params: wrong_api, headers: headers
    expect(response).to_not be_successful
    expect(response.status).to eq(401)

    post "/api/v1/road_trip", params: blank_api, headers: headers
    expect(response).to_not be_successful
    expect(response.status).to eq(401)
  end

  it "requires both an origin and destination cities" do
    headers = { "Content_Type": "application/json", "Accept": "application/json" }
    body = { "origin": "", "destination": "", "api_key": user.api_key }

    post "/api/v1/road_trip", params: body, headers: headers

    expect(response).to_not be_successful
    expect(response.status).to eq(400)
  end

  it "gives an impossrible route if the cities are not connected" do
    json_response_3 = File.read("spec/fixtures/road_trip/no_routes.json")
    stub_request(:post, "http://www.mapquestapi.com/directions/v2/routematrix?key=#{Rails.application.credentials.map_quest[:key]}").
    with(
      body: "{\"locations\":[\"New York, NY\",\"London, UK\"]}",
      headers: {
     'Accept'=>'*/*',
     'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     'User-Agent'=>'Faraday v2.10.1'
      }).
    to_return(status: 200, body: json_response_3, headers: {})

    allow(Time).to receive(:now).and_return(Time.parse("2024-04-24 02:22:40.541249 -0500"))
    coordinates = {lat: 51.50643, lng: -0.12719}
    date = "2024-04-24"
    hour = 7
    json_response_2 = File.read("spec/fixtures/road_trip/weather.json")
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?alerts=no&aqi=no&days=1&dt=2024-04-24&hour=2&key=#{Rails.application.credentials.weather[:key]}&query=51.50643,-0.12719").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: json_response_2, headers: {})
    

    headers = { "Content_Type": "application/json", "Accept": "application/json" }
    body = { "origin": "New York, NY", "destination": "London, UK", "api_key": user.api_key }

    post "/api/v1/road_trip", params: body, headers: headers

    expect(response).to be_successful
    expect(response.status).to eq(201)

    road_trip = JSON.parse(response.body, symbolize_names: true)[:data]
    trip_details = road_trip[:attributes]

    expect(road_trip[:id]).to eq(nil)
    expect(road_trip[:type]).to eq("road_trip")
    expect(trip_details[:start_city]).to eq("New York, NY")
    expect(trip_details[:end_city]).to eq("London, UK")
    expect(trip_details[:travel_time]).to eq("impossible route")
    expect(trip_details[:weather_at_eta]).to eq(nil)
  end
end