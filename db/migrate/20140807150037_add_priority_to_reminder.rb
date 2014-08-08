class AddPriorityToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :priority, :integer
    add_column :reminders, :completed, :boolean, default: false, null: false
  end
end
