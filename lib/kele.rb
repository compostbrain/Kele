require 'httparty'
require 'pp'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include Roadmap

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

  def get_mentor_availability
		mentor_id = get_me["current_enrollment"]["mentor_id"]
		response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { "authorization": @auth_token })
		JSON.parse(response.body)
	end

  def get_messages(page)
    response = self.class.get('/message_threads', headers: { authorization: @auth_token }, body: { page: page })
    JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, subject, stripped_text)
    body = {
      sender: sender,
      recipient_id: recipient_id,

      subject: subject,
      "stripped-text": stripped_text
    }

    response = self.class.post('/messages', headers: { authorization: @auth_token }, body: body)

  end

  def create_submission(assignment_branch, assignment_commit_link, checkpoint_id, comment)
    body = {
      assignment_branch: assignment_branch,
      assignment_commit_link: assignment_commit_link,
      checkpoint_id: checkpoint_id,
      comment: comment
    }


    response = self.class.post(/checkpoint_submissions, headers: {authorization: @auth_token}, body: body)

  end



end
