class RemoveCancelledAtFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :cancelled_at, :datetime
  end
end
