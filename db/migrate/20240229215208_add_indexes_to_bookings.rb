class AddIndexesToBookings < ActiveRecord::Migration[7.0]
  def change
    add_index :bookings, :start_time
    add_index :bookings, [:room_id, :start_time]
  end
end
