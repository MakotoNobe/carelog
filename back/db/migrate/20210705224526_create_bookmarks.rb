class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :office, null: false, foreign_key: true

      t.timestamps

      t.index [:user_id, :office_id], unique: true
    end
  end
end
