class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :require_valid_auth_token_and_set_session
  
  def require_valid_auth_token_and_set_session
    authenticate_or_request_with_http_token do |token, options|
      @session = Session.where(token: token).first
      @session.present?
    end
  end
end
