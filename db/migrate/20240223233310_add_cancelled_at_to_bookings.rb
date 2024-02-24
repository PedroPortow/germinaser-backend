class AddCancelledAtToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :cancelled_at, :datetime
  end
end
