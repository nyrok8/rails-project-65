# frozen_string_literal: true

class Web::ProfileController < Web::ApplicationController
  def index
    @q = current_user.bulletins.ransack(params[:q])
    @bulletins = @q.result
  end
end
