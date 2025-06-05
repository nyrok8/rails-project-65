# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  include Pundit::Authorization

  helper_method :current_user, :signed_in?

  allow_browser versions: :modern
end
