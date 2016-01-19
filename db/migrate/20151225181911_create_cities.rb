class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name, null: false, :unique => true

      t.timestamps null: false
    end
  end
end
