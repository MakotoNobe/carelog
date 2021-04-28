class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :city_number, foreign_key: true
      t.references :prefecture

      t.timestamps
    end
  end
end
