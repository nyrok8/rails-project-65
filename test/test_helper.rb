# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

OmniAuth.config.test_mode = true

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Automatically attach image to bulletins
    setup do
      attach_images_to_bulletins
    end

    private

    def attach_images_to_bulletins
      all_bulletins.each do |bulletin|
        next if bulletin.image.attached?

        bulletin.image.attach(
          io: Rails.root.join('test/fixtures/files/image.png').open,
          filename: 'image.png',
          content_type: 'image/png'
        )
      end
    end

    def all_bulletins
      Bulletin.all
    end
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user, _options = {})
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: user.email,
        name: user.name
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
  end

  def sign_out
    delete logout_path
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
