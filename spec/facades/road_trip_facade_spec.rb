require "rails_helper"

RSpec.describe RoadTripFacade do
  describe "road trip details" do
    it "returns time and weather between two cities" do
      json_response = File.read("spec/fixtures/road_trip/cincinnati_chicago.json")
      stub_request(:post, "http://www.mapquestapi.com/directions/v2/routematrix").
        with( query: { key: Rails.application.credentials.map_quest[:key] }).
        to_return(status: 200, body: json_response)

      allow(Time).to receive(:now).and_return(Time.parse("2024-04-24 02:22:40.541249 -0500"))
      coordinates = {lat: 41.88425, lng: -87.63245}
      date = "2024-04-24"
      hour = 7
      json_response_1 = File.read("spec/fixtures/road_trip/weather.json")
      
      stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?alerts=no&aqi=no&days=1&dt=2024-04-24&hour=7&key=#{Rails.application.credentials.weather[:key]}&query=41.88425,-87.63245").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.10.1'
          }).
         to_return(status: 200, body: json_response_1, headers: {})


      # require 'pry' ; binding.pry
      road_trip = RoadTripFacade.road_trip_details("Cincinnati, OH", "Chicago, IL")
      expect(road_trip).to be_a(RoadTrip)
    end
  end
end