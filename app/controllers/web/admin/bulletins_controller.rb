# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    @q = Bulletin.ransack(params[:q])
    @pagy, @bulletins = pagy(@q.result.order(created_at: :desc))
  end

  def under_moderation
    @pagy, @bulletins = pagy(Bulletin.under_moderation.order(created_at: :desc))
  end

  def reject
    bulletin = Bulletin.find(params[:id])

    return unless bulletin.may_reject?

    bulletin.reject!
    redirect_back fallback_location: root_path, notice: t('web.bulletins.done_actions.reject')
  end

  def publish
    bulletin = Bulletin.find(params[:id])

    return unless bulletin.may_publish?

    bulletin.publish!
    redirect_back fallback_location: root_path, notice: t('web.bulletins.done_actions.publish')
  end

  def archive
    bulletin = Bulletin.find(params[:id])

    return unless bulletin.may_archive?

    bulletin.archive!
    redirect_back fallback_location: root_path, notice: t('web.bulletins.done_actions.archive')
  end
end
