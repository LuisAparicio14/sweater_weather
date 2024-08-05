require "rails_helper"

RSpec.describe Forecast do
  it "exists and has attributes" do
    json = File.read("spec/fixtures/denver_forecast.json")
    data = JSON.parse(json, symbolize_names: true)
    forecast = Forecast.new(data)

    expect(forecast).to be_a(Forecast)
    expect(forecast.id).to eq(nil)
    expect(forecast.current_weather).to be_a(Hash)
    expect(forecast.daily_weather).to be_an(Array)
    expect(forecast.hourly_weather).to be_an(Array)
  end
end