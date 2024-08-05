require "rails_helper"

RSpec.describe BookService do
  it "can get books with the specific location given" do
    json_response_1 = File.read("spec/fixtures/book_search.json")
    stub_request(:get, "https://openlibrary.org/search.json?query=Denver,%20CO").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.10.1'
        }).
      to_return(status: 200, body: json_response_1, headers: {})
    parsed_response = BookService.get_books_for("Denver, CO")

    expect(parsed_response).to be_a(Hash)
    expect(parsed_response[:q]).to eq("denver,co")
    expect(parsed_response[:numFound]).to be_an(Integer)
    expect(parsed_response[:docs][0]).to include(:title, :isbn, :publisher)
  end
end