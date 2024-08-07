require "rails_helper"

RSpec.describe "User Registration API" do
  it "can register a new user" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "luis@email.com",
      "password": "most_secure_password",
      "password_confirmation": "most_secure_password"
    }

    post "/api/v1/users", params: body, headers: headers

    expect(response).to be_successful
    expect(response.status).to eq(201)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    user = parsed_response[:data]

    expect(user[:id]).to eq(User.last.id.to_s)
    expect(user[:type]).to eq("users")
    expect(user[:attributes]).to include(:email, :api_key)
  end

  it "cannot register a new user with missing information(sad path)" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "",
      "password": "",
      "password_confirmation": ""
    }

    post "/api/v1/users", params: body, headers: headers

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    errors = parsed_response[:errors]
    # require 'pry' ; binding.pry
    expect(errors[0][:status]).to eq(400)
    expect(errors[0][:detail]).to eq("Validation failed: Email can't be blank, Email is invalid, Password confirmation can't be blank, Password can't be blank")
  end

  it "password and password confirmation must match(sad path)" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "luis@email.com",
      "password": "most_secure_password",
      "password_confirmation": "that's_already_forgotten"
    }

    post "/api/v1/users", params: body, headers: headers

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    errors = parsed_response[:errors]

    expect(errors[0][:status]).to eq(400)
    expect(errors[0][:detail]).to eq("Validation failed: Password confirmation doesn't match Password")
  end

  it "email must be unique(sad path)" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "luis@",
      "password": "unique",
      "password_confirmation": "unique"
    }

    post "/api/v1/users", params: body, headers: headers

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    errors = parsed_response[:errors]

    expect(errors[0][:status]).to eq(400)
    expect(errors[0][:detail]).to eq("Validation failed: Email is invalid")
  end

  it "if you try to register an email for a second time it won't let you" do
    headers = {"Content_Type": "application/json", "Accept": "application/json"}
    body = {
      "email": "luis@email.com",
      "password": "most_secure_password",
      "password_confirmation": "most_secure_password"
    }

    post "/api/v1/users", params: body, headers: headers
    expect(response).to be_successful
    
    post "/api/v1/users", params: body, headers: headers
    expect(response).to_not be_successful
    expect(response.status).to eq(401)

    parsed_response = JSON.parse(response.body, symbolize_names: true)
    errors = parsed_response[:errors]

    expect(errors[0][:status]).to eq(401)
    expect(errors[0][:detail]).to eq("Validation failed: Email has already been taken")
  end
end