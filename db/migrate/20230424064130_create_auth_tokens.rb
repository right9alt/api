class CreateAuthTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :auth_tokens do |t|
      t.string :jti, null: false, unique: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :auth_tokens, :jti, unique: true
  end
end
