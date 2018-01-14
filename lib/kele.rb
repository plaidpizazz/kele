require 'httparty'
require 'json'

class Kele

  include HTTParty

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    authorization = self.class.post('/sessions', body: {
      email: email,
      password: password
      })
    @user_auth_token = authorization['auth_token']
    raise "Invalid Email or Password. Please Try Again" if @user_auth_token.nil?
  end

  def get_users
    response = self.class.get('/users/me', headers: { "authorization" => @user_auth_token })
    @data_hash = JSON.parse(response.body)
  end

end
