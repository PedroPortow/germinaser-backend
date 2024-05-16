class AddNameToFixedBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :fixed_bookings, :name, :string
  end
end
