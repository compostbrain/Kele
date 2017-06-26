require 'httparty'
require 'pp'
require 'json'

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


    def get_me
        response = self.class.get("/users/me", headers: { authorization: @auth_token })
        JSON.parse(response.body)
    end

end
