class CreateClinics < ActiveRecord::Migration[7.0]
  def change
    create_table :clinics do |t|
      t.string :name
      t.string :adress

      t.timestamps
    end
  end
end
