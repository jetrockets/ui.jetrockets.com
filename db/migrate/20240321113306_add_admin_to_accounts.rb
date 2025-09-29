class AddAdminToAccounts < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      add_column :accounts, :admin, :boolean, null: false, default: false
    end
  end
end
