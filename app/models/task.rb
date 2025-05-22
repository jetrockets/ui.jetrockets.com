class Task < ApplicationRecord
  validates :name, :file, :assigned_to, :due_date, presence: true
  validates :types, presence: true
  validate :types_valid

  private

  def types_valid
    errors.add(:types, "can't be empty") if types.empty?
    errors.add(:types, "can't have more than 2 items") if types.size > 2
  end
end

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  assigned_to :string
#  due_date    :date
#  file        :string
#  name        :string
#  types       :string           default([]), is an Array
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
