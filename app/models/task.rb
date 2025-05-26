class Task < ApplicationRecord
  validates :name, :file, :assigned_to, :due_date, presence: true
  validates :types, presence: true, length: { maximum: 2 }
end

# == Schema Information
#
# Table name: tasks
#
#  id           :bigint           not null, primary key
#  assigned_to  :string
#  due_date     :date
#  file         :string
#  is_completed :boolean          default(FALSE), not null
#  name         :string
#  types        :string           default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
