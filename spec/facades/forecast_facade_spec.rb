require "rails_helper"

RSpec.describe ForecastFacade do
  it "can get coordinates" do
    json = File.read("spec/fixtures/denver_coord.json")
    stub_request(:get, "http://www.mapquestapi.com/geocoding/v1/address").
      with(
        query: {
          key: Rails.application.credentials.map_quest[:api_key],
          location: 'Denver, CO'
        }
      ).to_return(status: 200, body: json)

    # stub_request(:get, "http://api.weatherapi.com/geocoding/v1/address?key&location=Denver,%20CO").
    #   with(
    #     headers: {
    #     'Accept'=>'*/*',
    #     'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
    #     'User-Agent'=>'Faraday v2.10.1'
    #     }).
    #   to_return(status: 200, body: json, headers: {})
    coord = ForecastFacade.get_coordinates("Denver, CO")

    expect(coord).to be_a(Hash)
    expect(coord[:lat]).to eq(39.74001)
    expect(coord[:lng]).to eq(-104.99202)
  end

  it "can get weather" do
    coord = {lat: 39.74001, lng: -104.99202}
    json = File.read("spec/fixtures/denver_forecast.json")
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?alerts=no&aqi=no&days=5&key&query=39.74001,-104.99202").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: json, headers: {})
    
    forecast = ForecastFacade.get_weather(coord)

    expect(forecast).to be_a(Forecast)
    expect(forecast.current_weather).to be_a(Hash)
    expect(forecast.daily_weather).to be_an(Array)
    expect(forecast.hourly_weather).to be_an(Array)
  end
end