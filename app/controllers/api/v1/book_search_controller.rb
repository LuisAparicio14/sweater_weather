class Api::V1::BookSearchController < ApplicationController
  def index
    books = BookFacade.get_books(params[:title])
    render json: BookSerializer.new(books)
  end
end