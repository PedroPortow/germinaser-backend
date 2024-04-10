class AddCreditsReturnedToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :credit_return_pending, :boolean, default: false
  end
end
