class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :name
      t.date :date
      t.integer :client_id
      t.boolean :status
      t.string :description

      t.timestamps
    end
  end
end
