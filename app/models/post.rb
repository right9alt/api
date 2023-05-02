class Post < ApplicationRecord
  #belongs_to
  belongs_to :user
  #has_many
  has_many :comments, dependent: :destroy
  has_many :likeables, as: :likeable, dependent: :destroy
  has_many :likes, through: :likeables, source: :user
end
