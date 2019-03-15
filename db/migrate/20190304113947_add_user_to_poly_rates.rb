class AddUserToPolyRates < ActiveRecord::Migration[5.2]
  def change
    add_reference :poly_rates, :user, foreign_key: true
  end
end
