class SessionsController < ApplicationController
  skip_before_action :require_valid_auth_token_and_set_session
  
  def create
    session = Session.where(email: session_params[:email]).first_or_initialize
    session.update(session_params)
    if session.valid?
      render json: {token: session.token}
    else
      render json: {errors: session.errors}, status: :unprocessable_entity
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
