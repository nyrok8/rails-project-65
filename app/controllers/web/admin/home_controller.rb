# frozen_string_literal: true

class Web::Admin::HomeController < Web::Admin::ApplicationController
  def index
    @bulletins = Bulletin.under_moderation.order(created_at: :desc)
    authorize @bulletins, :home_index?
  end
end
