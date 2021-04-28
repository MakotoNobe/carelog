class CreatePrefectures < ActiveRecord::Migration[6.1]
  def change
    create_table :prefectures do |t|
      t.string :name
      t.references :area, foreign_key: true

      t.timestamps
    end
  end
end
