# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :account

  def admin?
    account&.admin?
  end
end
