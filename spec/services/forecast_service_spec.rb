require "rails_helper"

RSpec.describe ForecastService do
  it "can get coordinates" do
    json = File.read("spec/fixtures/denver_coord.json")
    stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address").
      with(
        query: {
          key: Rails.application.credentials.map_quest[:key],
          location: 'Denver, CO'
        }
      ).to_return(status: 200, body: json)

    coord = ForecastService.get_coordinates("Denver, CO")

    expect(coord).to be_a(Hash)
    expect(coord[:results]).to be_an(Array)

    results = coord[:results].first
    expect(results[:locations]).to be_an(Array)

    locations = results[:locations].first
    expect(locations).to be_a(Hash)
    expect(locations[:latLng]).to be_a(Hash)
    expect(locations[:latLng]).to include(:lat, :lng)
  end

  it "can get weather" do
    coord = {lat: 39.74001, lng: -104.99202}
    json = File.read("spec/fixtures/denver_forecast.json")
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?alerts=no&aqi=no&days=5&key=#{Rails.application.credentials.weather[:key]}&query=39.74001,-104.99202").
    with(
      headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v2.10.1'
      }).
    to_return(status: 200, body: json, headers: {})
    forecast = ForecastService.get_weather(coord)

    expect(forecast).to be_a(Hash)
    expect(forecast).to include(:current, :forecast)
    expect(forecast[:current]).to be_a(Hash)
    expect(forecast[:forecast]).to be_a(Hash)
    expect(forecast[:forecast]).to include(:forecastday)

    current = forecast[:current]
    expect(current).to include(:last_updated, :temp_f, :feelslike_f, :humidity, :uv, :vis_miles, :condition)
    expect(current[:condition]).to include(:icon)

    forecastday = forecast[:forecast][:forecastday]
    expect(forecastday).to be_an(Array)
    expect(forecastday.size).to eq(5)
    expect(forecastday).to all(include(:date, :astro, :day))
  end
end