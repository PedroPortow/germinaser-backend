class DropCancelations < ActiveRecord::Migration[6.0]
  def change
    drop_table :cancelations do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :cancelled_at
      
      t.timestamps
    end
  end
end
