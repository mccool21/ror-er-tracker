class OmniauthCallbacksController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    user = User.from_omniauth(request.env["omniauth.auth"])
    start_new_session_for user
    redirect_to after_authentication_url, notice: "Signed in with Google."
  end

  def failure
    redirect_to new_session_path, alert: "Google sign-in failed: #{params[:message]&.humanize}"
  end
end
