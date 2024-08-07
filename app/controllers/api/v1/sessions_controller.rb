class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by!(email: params[:email])
    if user&.authenticate(params[:password])
      render json: UsersSerializer.new(user), status: :ok
    else
      render json: { errors:[{ status: 401, detail: "Invalid credentials" }] }, status: :unauthorized
    end
  end
end