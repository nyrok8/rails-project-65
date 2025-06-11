# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  before_action :authenticate_user!

  def show
    @q = current_user.bulletins.ransack(params[:q])
    @pagy, @bulletins = pagy(@q.result)
  end
end
