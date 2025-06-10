# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    sign_in @admin

    @category = categories(:one)
  end

  test 'should get index' do
    get admin_categories_url
    assert_response :success
  end

  test 'should get new' do
    get new_admin_category_url
    assert_response :success
  end

  test 'should get edit' do
    get edit_admin_category_url(@category)
    assert_response :success
  end

  test 'should create category' do
    assert_difference('Category.count', 1) do
      post admin_categories_url, params: { category: { name: 'Created Category' } }
    end

    created = Category.find_by(name: 'Created Category')
    assert { created }
    assert_redirected_to admin_categories_url
  end

  test 'should not create category with invalid data' do
    assert_no_difference('Category.count') do
      post admin_categories_url, params: { category: { name: '' } }
    end

    assert_response :unprocessable_entity
  end

  test 'should update category' do
    patch admin_category_url(@category), params: { category: { name: 'Updated Name' } }

    assert_redirected_to admin_categories_url
    @category.reload
    assert { @category.name == 'Updated Name' }
  end

  test 'should not update category with invalid data' do
    patch admin_category_url(@category), params: { category: { name: '' } }

    assert_response :unprocessable_entity
    @category.reload
    assert { @category.name.present? }
  end

  test 'should destroy category' do
    empty_category = categories(:two)

    assert_difference('Category.count', -1) do
      delete admin_category_url(empty_category)
    end

    assert_redirected_to admin_categories_url
  end

  test 'should not destroy category with bulletins' do
    assert_no_difference('Category.count') do
      delete admin_category_url(@category)
    end

    assert_redirected_to admin_categories_url
  end

  test 'should not allow guest access' do
    sign_out

    get admin_categories_url
    assert_redirected_to root_url

    get new_admin_category_url
    assert_redirected_to root_url

    get edit_admin_category_url(@category)
    assert_redirected_to root_url

    post admin_categories_url, params: { category: { name: 'GuestFail' } }
    assert_redirected_to root_url

    patch admin_category_url(@category), params: { category: { name: 'GuestFail' } }
    assert_redirected_to root_url

    delete admin_category_url(@category)
    assert_redirected_to root_url
  end
end
