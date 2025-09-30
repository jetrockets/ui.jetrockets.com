class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.references :account, null: false, foreign_key: true, index: { unique: true }
      t.string :first_name
      t.string :last_name
      t.json :avatar_data

      t.timestamps
    end
  end
end
