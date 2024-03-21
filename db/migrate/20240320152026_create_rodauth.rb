class CreateRodauth < ActiveRecord::Migration[7.0]
  def change
    enable_extension "citext"

    create_table :accounts do |t|
      t.integer :status, null: false, default: 1
      t.citext :email, null: false
      t.index :email, unique: true, where: "status IN (1, 2)"
      t.string :password_hash
    end

    # Used by the password reset feature
    create_table :account_password_reset_keys, id: false do |t|
      t.bigint :id, primary_key: true
      t.foreign_key :accounts, column: :id
      t.string :key, null: false
      t.datetime :deadline, null: false
      t.datetime :email_last_sent, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # Used by the account verification feature
    create_table :account_verification_keys, id: false do |t|
      t.bigint :id, primary_key: true
      t.foreign_key :accounts, column: :id
      t.string :key, null: false
      t.datetime :requested_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :email_last_sent, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end

    # Used by the verify login change feature
    create_table :account_login_change_keys, id: false do |t|
      t.bigint :id, primary_key: true
      t.foreign_key :accounts, column: :id
      t.string :key, null: false
      t.string :login, null: false
      t.datetime :deadline, null: false
    end

    # Used by the remember me feature
    create_table :account_remember_keys, id: false do |t|
      t.bigint :id, primary_key: true
      t.foreign_key :accounts, column: :id
      t.string :key, null: false
      t.datetime :deadline, null: false
    end
  end
end
