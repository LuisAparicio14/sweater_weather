class Api::V1::RoadTripController < ApplicationController
  def create
    user = User.find_by(api_key: params[:api_key])
    if user && (params[:origin] && params[:destination]).present?
      road_trip = RoadTripFacade.road_trip_details(params[:origin], params[:destination])
      render json: RoadTripSerializer.new(road_trip), status: :created
    elsif params[:origin].blank? || params[:destination].blank?
      render json: { errors:[{ status: 400, detail: "Origin and destination must be present" }] }, status: :bad_request
    else
      render json: { errors:[{ status: 401, detail: "Unauthorized" }] }, status: :unauthorized
    end
  end
end