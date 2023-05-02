class Comment < ApplicationRecord
  #belongs_to
  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: 'Comment', optional: true
  #has_many
  has_many :comments, foreign_key: :parent_id, dependent: :destroy
  has_many :likeables, as: :likeable, dependent: :destroy
  has_many :likes, through: :likeables, source: :user

end
