class AddCanceledAtToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :canceled_at, :datetime
  end
end
