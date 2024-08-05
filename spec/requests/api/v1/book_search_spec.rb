require "rails_helper"

RSpec.describe "get book search end point" do
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

    params = {"location":"Denver, CO", "quantity": 5}
    headers = {"Content_Type": "application/json", "Accept": "application/json"}

    get "/api/v1/book_search", params: params, headers: headers

    expect(response).to be_successful
    parsed_response = JSON.parse(response.body, symbolize_names: true)
    books = parsed_response[:data]
    expect(books[:id]).to eq(nil)
    expect(books[:type]).to eq("book")
    expect(books[:attributes]).to include(:destination, :forecast, :total_books_found, :books)
    expect(books[:attributes][:destination]).to eq("Denver, CO")
    expect(books[:attributes][:total_books_found]).to be_an(Integer)

    book_list = books[:attributes][:books]
    expect(book_list).to be_an(Array)
    expect(book_list.size).to eq(5)
    expect(book_list).to all(be_a(Hash))
    expect(book_list).to all(include(:isbn, :title, :publisher))
    expect(book_list[0][:isbn]).to be_an(Array)
    expect(book_list[0][:publisher]).to be_an(Array)

    forecast = books[:attributes][:forecast]
    expect(forecast).to be_a(Hash)
    expect(forecast).to include(:summary, :temperature)
  end
end