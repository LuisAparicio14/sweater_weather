require "rails_helper"

RSpec.describe "POST /api/v1/sessions", type: :request do
  let!(:user) { User.create!(email: "luis@email.com", password: "most_secure_password", password_confirmation: "most_secure_password", api_key: "a1h3jb3bj3bb32b3j23b3j3bj2") }

  it "creates session when user logs in(happy path)" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "luis@email.com",
      "password": "most_secure_password",
    }

    post "/api/v1/sessions", params: body, headers: headers

    expect(response).to be_successful
    expect(response.status).to eq(200)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    session = parsed_response[:data]

    expect(session[:id].to_i).to eq(user.id)
    expect(session[:type]).to eq("users")
    expect(session[:attributes][:email]).to eq(user.email)
    expect(session[:attributes][:api_key]).to eq(user.api_key)
  end

  it "provide the field email(sad path)" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "",
      "password": "",
    }

    post "/api/v1/sessions", params: body, headers: headers

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    errors = parsed_response[:errors]

    expect(errors[0][:status]).to eq(404)
    expect(errors[0][:detail]).to eq("Couldn't find User")
  end

  it "provide the field password when created(sad path)" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "luis@email.com",
      "password": "",
    }

    post "/api/v1/sessions", params: body, headers: headers

    expect(response).to_not be_successful
    # require 'pry' ; binding.pry
    expect(response.status).to eq(401)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    errors = parsed_response[:errors]
    # require 'pry' ; binding.pry
    expect(errors[0][:status]).to eq(401)
    expect(errors[0][:detail]).to eq("Invalid credentials")
  end

  it "valid user email(sad path)" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "hello@email.com",
      "password": "most_secure_password",
    }

    post "/api/v1/sessions", params: body, headers: headers

    expect(response).to_not be_successful
    expect(response.status).to eq(404)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    errors = parsed_response[:errors]

    expect(errors[0][:status]).to eq(404)
    expect(errors[0][:detail]).to eq("Couldn't find User")
  end

  it "valid password(sad path)" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "luis@email.com",
      "password": "incorrect",
    }

    post "/api/v1/sessions", params: body, headers: headers

    expect(response).to_not be_successful
    expect(response.status).to eq(401)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    errors = parsed_response[:errors]

    expect(errors[0][:status]).to eq(401)
    expect(errors[0][:detail]).to eq("Invalid credentials")
  end
end