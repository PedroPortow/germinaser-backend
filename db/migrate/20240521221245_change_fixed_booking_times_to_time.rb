class ChangeFixedBookingTimesToTime < ActiveRecord::Migration[7.0]
  def up
    change_column :fixed_bookings, :start_time, :time
    change_column :fixed_bookings, :end_time, :time
  end

  def down
    change_column :fixed_bookings, :start_time, :datetime
    change_column :fixed_bookings, :end_time, :datetime
  end
end
