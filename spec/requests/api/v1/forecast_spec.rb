require "rails_helper"

RSpec.describe "get forecast end point" do
  it "can get forecast for a city" do
    json = File.read("spec/fixtures/denver_coord.json")

    stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address?key&location=Denver,%20CO").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: json, headers: {})

    coord = {lat: 39.74001, lng: -104.99202}
    json_response = File.read("spec/fixtures/denver_forecast.json")
    
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?alerts=no&aqi=no&days=5&key&query=39.74001,-104.99202").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: json_response, headers: {})

    params = {"location":"Denver, CO"}
    headers = {"Content_Type": "application/json", "Accept": "application/json"}

    get "/api/v1/forecast", params: params, headers: headers
    expect(response).to be_successful
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    
    forecast = parsed_response[:data]
    expect(forecast[:id]).to eq(nil)
    expect(forecast[:type]).to eq("forecast")
    expect(forecast[:attributes]).to include(:current_weather, :daily_weather, :hourly_weather)
    
    current_weather = forecast[:attributes][:current_weather]
    expect(current_weather).to include(:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon)
    
    daily_weather = forecast[:attributes][:daily_weather]
    expect(daily_weather).to be_an(Array)
    expect(daily_weather.size).to eq(5)
    expect(daily_weather).to all(include(:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon))
    
    # hourly_weather = forecast[:attributes][:hourly_weather]
    # expect(hourly_weather).to be_an(Array)
    # require 'pry' ; binding.pry
    # expect(hourly_weather.size).to eq(24)
    # expect(hourly_weather).to all(include(:time, :temperature, :conditions, :icon))
  end
end