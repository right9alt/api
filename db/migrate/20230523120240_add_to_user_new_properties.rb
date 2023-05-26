class AddToUserNewProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :phone_number, :string
    add_column :users, :tag, :string
    add_column :users, :profile_status, :string
    add_column :users, :role, :integer, null: false
    add_column :users, :uid, :string, unique: true
  end
end