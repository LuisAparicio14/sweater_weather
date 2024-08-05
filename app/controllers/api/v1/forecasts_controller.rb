class Api::V1::ForecastsController < ApplicationController
  def show
    coord = ForecastFacade.get_coordinates(params[:location])
    forecast = ForecastFacade.get_weather(coord)
    render json: ForecastSerializer.new(forecast)
  end
end