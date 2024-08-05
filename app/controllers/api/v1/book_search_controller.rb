class Api::V1::BookSearchController < ApplicationController
  def index
    books = BookFacade.get_books(params[:location], params[:quantity])
    render json: BookSerializer.new(books)
  end
end