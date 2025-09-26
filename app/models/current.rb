class Current < ActiveSupport::CurrentAttributes
  attribute :account, :user

  def admin?
    account&.admin?
  end
end
