class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :file
      t.string :types, array: true, default: []
      t.string :assigned_to
      t.date :due_date

      t.timestamps
    end
  end
end
