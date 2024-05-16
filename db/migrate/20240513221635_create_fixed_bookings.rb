class CreateFixedBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :fixed_bookings do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :day_of_week, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end
  end
end
