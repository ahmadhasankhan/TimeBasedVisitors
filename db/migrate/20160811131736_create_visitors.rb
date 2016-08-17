class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.integer :ticked_id, index: true
      t.integer :event_type, index: true
      t.integer :event_time, index: true

      t.timestamps null: false
    end
  end
end
