# frozen_string_literal: true

class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  def index
    @pagy, @categories = pagy(Category.order(:name))
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to admin_categories_path, notice: t('.success')
    else
      flash[:alert] = t('.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to admin_categories_path, notice: t('.success')
    else
      flash[:alert] = t('.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    category = Category.find(params[:id])

    if category.destroy
      redirect_to admin_categories_path, notice: t('.success')
    else
      flash[:alert] = category.errors.full_messages.to_sentence
      redirect_to admin_categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
