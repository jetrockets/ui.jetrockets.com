# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  account_id  :integer          not null
#  first_name  :string
#  last_name   :string
#  avatar_data :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_users_on_account_id  (account_id) UNIQUE
#

class User < ApplicationRecord
  include ::AvatarUploader::Attachment(:avatar)

  belongs_to :account

  validates :first_name, :last_name, presence: true, on: :update

  def full_name
    ("#{first_name} #{last_name}".strip).presence
  end
end
