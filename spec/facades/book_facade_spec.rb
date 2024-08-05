require "rails_helper"

RSpec.describe BookFacade do
  it "can get books" do
    json_response_1 = File.read("spec/fixtures/book_search.json")
    stub_request(:get, "https://openlibrary.org/search.json?q=Denver,%20CO").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.10.1'
        }).
        to_return(status: 200, body: json_response_1, headers: {})
    
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
    
    result = BookFacade.get_books("Denver, CO", 5)
    expect(result).to be_a(Book)
    expect(result.books).to be_an(Array)
    expect(result.books).to all(include(:isbn, :title, :publisher))
    expect(result.forecast).to be_a(Hash)
    expect(result.total_books_found).to be_an(Integer)
    expect(result.destination).to eq("Denver, CO")
  end
end