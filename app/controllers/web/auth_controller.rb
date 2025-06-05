# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    user = User.find_or_initialize_by(email: auth.info.email)
    user.name ||= auth.info.name
    user.save

    sign_in(user)
    redirect_to root_path
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
