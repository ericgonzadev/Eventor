class CreateAttends < ActiveRecord::Migration[5.0]
  def change
    create_table :attends do |t|
      t.integer :attendee_id
      t.integer :attended_event_id

      t.timestamps null: false
    end
    add_index :attends, :attendee_id
    add_index :attends, :attended_event_id
    add_index :attends, [:attendee_id, :attended_event_id], unique: true
  end
end
