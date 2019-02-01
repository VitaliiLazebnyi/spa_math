require "rails_helper"

describe "User", type: :request do
  let(:login) { "login" }
  let(:login_invalid) { "" }
  let(:password) { "password" }
  let(:password_invalid) { "" }
  let(:headers) { {"Content-Type" => "application/json",
                   "Accept" => "application/json"} }
  let(:user) { FactoryBot.create(:user) }


  def api_signup(l, p)
    post "/api/signup",
         params: {
             data: {
                 login: l,
                 password: p
             }
         }.to_json,
         headers: headers
  end

  def api_login(l, p)
    post "/api/login",
         params: {
             data: {
                 login: l,
                 password: p
             }
         }.to_json,
         headers: headers
  end

  def response
    JSON.parse(body)
  end

  it "can signup with valid credentials" do
    api_signup(login, password)
    expect(response["data"]["login"]).to eq login
  end

  it "can't signup with invalid credentials" do
    api_signup(login_invalid, password_invalid)
    expect(response["data"]["login"]).to eq ["can't be blank"]
    expect(response["data"]["password"]).to eq ["can't be blank"]
  end

  it "can login with valid credentials" do
    api_login(user.login, user.password)
    expect(response["data"]["login"]).to eq user.login
    expect(response["token"].size).to eq 52
  end

  it "can't login with invalid login" do
    api_login(user.login, password_invalid)
    expect(response["data"]["login"]).to eq nil
    expect(response["token"]).to eq nil
    expect(response["data"]["errors"]).to eq ["login or password were incorrect."]
  end

  it "can't login with invalid password" do
    api_login(login_invalid, user.password)
    expect(response["data"]["login"]).to eq nil
    expect(response["token"]).to eq nil
    expect(response["data"]["errors"]).to eq ["login or password were incorrect."]
  end
end
