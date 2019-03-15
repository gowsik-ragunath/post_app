class CreatePolyRates < ActiveRecord::Migration[5.2]
  def change
    create_table :poly_rates do |t|
      t.integer :rating
      t.references :rateable, polymorphic: true

      t.timestamps
    end
  end
end
