class AddRelationToComment < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :relation_to, :integer, null: true
  end
end
