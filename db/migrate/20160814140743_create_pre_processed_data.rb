class CreatePreProcessedData < ActiveRecord::Migration
  def change
    create_table :pre_processed_data do |t|
      t.integer :event_time
      t.integer :entry
      t.integer :exit
      t.integer :current_visitors
      t.integer :till_now

      t.timestamps null: false
    end
  end
end
