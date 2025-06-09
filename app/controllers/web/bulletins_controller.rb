# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @q = Bulletin.published.ransack(params[:q])
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
      redirect_to @bulletin, notice: t('.success')
    else
      flash[:alert] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin

    if @bulletin.update(bulletin_params)
      redirect_to @bulletin, notice: t('.success')
    else
      flash[:alert] = t('.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def profile
    authorize Bulletin
    @q = current_user.bulletins.ransack(params[:q])
    @pagy, @bulletins = pagy(@q.result)
  end

  def to_moderate
    bulletin = Bulletin.find(params[:id])
    authorize bulletin

    return unless bulletin.may_to_moderate?

    bulletin.to_moderate!
    redirect_back fallback_location: root_path, notice: t('web.bulletins.done_actions.to_moderate')
  end

  def archive
    bulletin = Bulletin.find(params[:id])
    authorize bulletin

    return unless bulletin.may_archive?

    bulletin.archive!
    redirect_back fallback_location: root_path, notice: t('web.bulletins.done_actions.archive')
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :category_id, :image)
  end
end
