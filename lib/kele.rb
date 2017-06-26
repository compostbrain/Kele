require 'httparty'
require 'pp'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(user, password)
    @user = user
    @password = password

    response = self.class.post('/sessions', body: { "email": @user, "password": @password })

    pp response.message
    @auth_token = response["auth_token"]
  end

end
