class AddCreditsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :credits, :integer, default: 0
  end
end
