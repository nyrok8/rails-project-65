# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  def index
    @q = Bulletin.ransack(params[:q])
    @bulletins = @q.result.order(created_at: :desc)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def new
    @bulletin = Bulletin.new
    authorize @bulletin
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
  end

  def create
    @bulletin = current_user.bulletins.build(bulletin_params)
    authorize @bulletin

    if @bulletin.save
      redirect_to bulletin
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    bulletin = Bulletin.find(params[:id])
    authorize bulletin

    if bulletin.update(bulletin_params)
      redirect_to bulletin
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def to_moderate
    bulletin = Bulletin.find(params[:id])
    authorize bulletin

    return unless bulletin.may_to_moderate?

    bulletin.to_moderate!
    redirect_back fallback_location: root_path
  end

  def reject
    bulletin = Bulletin.find(params[:id])
    authorize bulletin

    return unless bulletin.may_reject?

    bulletin.reject!
    redirect_back fallback_location: root_path
  end

  def publish
    bulletin = Bulletin.find(params[:id])
    authorize bulletin

    return unless bulletin.may_publish?

    bulletin.publish!
    redirect_back fallback_location: root_path
  end

  def archive
    bulletin = Bulletin.find(params[:id])
    authorize bulletin

    return unless bulletin.may_archive?

    bulletin.archive!
    redirect_back fallback_location: root_path
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end
end
