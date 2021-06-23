class CreateOffices < ActiveRecord::Migration[6.1]
  def change
    create_table :offices do |t|
      t.string :provider
      t.string :uid
      t.string :encrypted_password
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.boolean :allow_password_change
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.string :password
      t.string :name
      t.string :title
      t.string :postcode
      t.string :address
      t.string :near_station
      t.string :tel
      t.string :fax
      t.string :email
      t.string :company
      t.text :url
      t.text :introduction
      t.float :latitude
      t.float :longitude
      t.integer :city_id
      t.string :staff_number
      t.string :city_number
      t.boolean :status
      t.text :tokens

      t.timestamps
    end
  end
end
