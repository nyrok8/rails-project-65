# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    return true if record.published?

    record.user_id == user.id || user.admin?
  end

  def create?
    true
  end

  def update?
    record.user_id == user.id
  end

  def to_moderate?
    record.user_id == user.id
  end

  def reject?
    true
  end

  def publish?
    true
  end

  def archive?
    record.user_id == user.id
  end
end
