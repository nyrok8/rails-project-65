# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:admin)
    sign_in @admin

    @draft = bulletins(:draft)
    @under_moderation = bulletins(:under_moderation)
  end

  test 'should get index' do
    get admin_bulletins_url
    assert_response :success
  end

  test 'should get under moderation list' do
    get admin_root_url
    assert_response :success
  end

  test 'should publish bulletin' do
    patch publish_admin_bulletin_url(@under_moderation)
    assert_redirected_to root_url

    @under_moderation.reload
    assert { @under_moderation.published? }
  end

  test 'should reject bulletin' do
    patch reject_admin_bulletin_url(@under_moderation)
    assert_redirected_to root_url

    @under_moderation.reload
    assert { @under_moderation.rejected? }
  end

  test 'should archive bulletin' do
    patch archive_admin_bulletin_url(@under_moderation)
    assert_redirected_to root_url

    @under_moderation.reload
    assert { @under_moderation.archived? }
  end

  test 'should not allow guest access' do
    sign_out

    get admin_bulletins_url
    assert_redirected_to root_url

    patch publish_admin_bulletin_url(@under_moderation)
    assert_redirected_to root_url
  end
end
