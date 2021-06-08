class CreateOffices < ActiveRecord::Migration[6.1]
  def change
    create_table :offices do |t|
      t.string :office_name
      t.string :phone_number
      t.string :fax
      t.string :postal_code
      t.string :address
      t.string :closest_station
      t.integer :staff_count
      t.string :business_entity
      t.string :site_url
      t.string :feature_title
      t.string :feature_deatail
      t.string :email
      t.string :password_digest
      t.string :remember_digest
      t.references :city, foreign_key: true

      t.timestamps
    end
  end
end
