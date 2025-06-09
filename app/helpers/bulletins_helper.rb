# frozen_string_literal: true

module BulletinsHelper
  def state_name(state)
    key = state.respond_to?(:state) ? state.state : state.to_s
    I18n.t("activerecord.attributes.bulletin.aasm.states.#{key}", default: key.humanize)
  end

  def state_options
    Bulletin.aasm.states.map do |state|
      [state_name(state.name), state.name]
    end
  end
end
