class User < ApplicationRecord
  has_secure_password
  #belongs_to
  #has_many
  has_many :auth_tokens, dependent: :delete_all
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likeables

  validates :email, presence: true, uniqueness: true
end
