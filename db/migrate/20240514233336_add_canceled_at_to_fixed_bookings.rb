class AddCanceledAtToFixedBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :fixed_bookings, :canceled_at, :datetime
  end
end
