class CreateLikeables < ActiveRecord::Migration[7.0]
  def change
    create_table :likeables do |t|
      t.references :user, null: false, foreign_key: true
      t.references :likeable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
