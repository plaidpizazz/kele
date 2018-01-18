require 'httparty'
require 'json'
require './lib/roadmap'

class Kele

  include HTTParty
  include Roadmap

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    authorization = self.class.post('/sessions', body: {
      email: email,
      password: password
      })
    @user_auth_token = authorization['auth_token']
    raise "Invalid Email or Password. Please Try Again" if @user_auth_token.nil?
  end

  def get_me
    response = self.class.get("/users/me", headers: { "authorization" => @user_auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability
    # example mentor_id = 2292457
    response = self.class.get("/mentors/2292457/student_availability", headers: { "authorization" => @user_auth_token })
    JSON.parse(response.body)
  end

  def get_messages(page = 0)
    if page > 0
      message_num = "/message_threads?page=#{page}"
    else
      message_num = "/message_threads"
    end
    response = self.class.get(message_num, headers: { "authorization" => @user_auth_token })
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token = nil, subject, stripped_text)
    response = self.class.post("/messages", headers: { "authorization" => @user_auth_token }, body: {
        sender: sender,
        recipient_id: recipient_id,
        token: token,
        subject: subject,
        stripped_text: stripped_text
        })
    p "Your message was sent!"
  end

end
