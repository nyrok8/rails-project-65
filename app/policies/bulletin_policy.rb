# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && record.user == user
  end

  def to_moderate?
    user.present? && record.user == user
  end

  def reject?
    user.present? && user.admin?
  end

  def publish?
    user.present? && user.admin?
  end

  def archive?
    user.present? && (record.user == user || user.admin?)
  end

  def profile?
    user.present?
  end

  def admin_index?
    user.present? && user.admin?
  end

  def under_moderation?
    user.present? && user.admin?
  end
end
