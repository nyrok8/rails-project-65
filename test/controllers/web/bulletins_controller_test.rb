# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user

    @category = categories(:one)

    @draft = bulletins(:draft)
    @published = bulletins(:published)

    @params = {
      title: 'Test Bulletin',
      description: 'Test Bulletin description',
      category_id: @category.id,
      image: fixture_file_upload('image.png', 'image/png')
    }
  end

  test 'should get index' do
    sign_out
    get bulletins_url
    assert_response :success
  end

  test 'should get show' do
    get bulletin_url(@published)
    assert_response :success
  end

  test 'should get new' do
    get new_bulletin_url
    assert_response :success
  end

  test 'should redirect new when not signed in' do
    sign_out
    get new_bulletin_url

    assert_redirected_to root_url
  end

  test 'should create bulletin' do
    assert_difference('Bulletin.count', 1) do
      post bulletins_url, params: { bulletin: @params }
    end

    created = Bulletin.find_by(@params.except(:image).merge(user_id: @user.id))
    assert { created }
    assert_redirected_to bulletin_url(created)
  end

  test 'should redirect create when not signed in' do
    sign_out

    assert_no_difference('Bulletin.count') do
      post bulletins_url, params: { bulletin: @params }
    end

    assert_redirected_to root_url
  end

  test 'should not create bulletin with invalid data' do
    invalid_params = {
      title: '',
      description: '',
      category_id: @category.id
    }

    assert_no_difference('Bulletin.count') do
      post bulletins_url, params: { bulletin: invalid_params }
    end

    assert_response :unprocessable_entity
  end

  test 'should get edit' do
    get edit_bulletin_url(@draft)
    assert_response :success
  end

  test 'should update bulletin' do
    patch bulletin_url(@draft), params: {
      bulletin: {
        title: 'Updated title',
        description: 'Updated description'
      }
    }

    assert_redirected_to bulletin_url(@draft)
    @draft.reload
    assert { @draft.title == 'Updated title' }
  end

  test 'should not update bulletin with invalid data' do
    patch bulletin_url(@draft), params: {
      bulletin: {
        title: '',
        description: ''
      }
    }

    assert_response :unprocessable_entity
    @draft.reload
    assert { @draft.title.present? }
  end

  test 'should to_moderate bulletin' do
    patch to_moderate_bulletin_url(@draft)
    assert_redirected_to root_url
    @draft.reload
    assert { @draft.under_moderation? }
  end

  test 'should archive bulletin' do
    patch archive_bulletin_url(@draft)
    assert_redirected_to root_url
    @draft.reload
    assert { @draft.archived? }
  end
end
