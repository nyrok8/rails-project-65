# frozen_string_literal: true

class Web::Admin::ApplicationController < Web::ApplicationController
  before_action :authenticate_admin!

  def authenticate_admin!
    return if signed_in? && current_user.admin?

    redirect_to root_path, alert: t('web.auth.unauthorized')
  end
end
