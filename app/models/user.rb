class User < ApplicationRecord
  include ::AvatarUploader::Attachment(:avatar)

  belongs_to :account

  validates :first_name, :last_name, presence: true, on: :update

  def full_name
    ("#{first_name} #{last_name}".strip).presence
  end
end
