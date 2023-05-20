class User < ApplicationRecord
  has_secure_password
  #belongs_to
  #has_many
  has_many :auth_tokens, dependent: :delete_all
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likeables, dependent: :destroy
  has_many :liked_posts, through: :likeables, source: :likeable, source_type: 'Post'
  has_many :liked_comments, through: :likeables, source: :likeable, source_type: 'Comment'
  #Followers
  has_many :following_users,
  foreign_key: :followee_id,
  class_name: 'Relationship',
  dependent: :destroy
  has_many :followers, through: :following_users, dependent: :destroy
  #Followees
  has_many :followed_users,
  foreign_key: :follower_id,
  class_name: 'Relationship',
  dependent: :destroy
  has_many :followees, through: :followed_users, dependent: :destroy

  has_one_attached :avatar
  has_one_attached :profile_header
  #validates
  validates :email, presence: true, uniqueness: true


 #TODO: move logic to servise
  def following?(user)
    followees&.include?(user)
  end

  def liked?(object)
    if object.class.name == "Post"
      liked_posts.include?(object)
    else
      liked_comments.include?(object)
    end
  end
 
  def follow(user)
    relation = Relationship.find_by(follower_id: self.id, followee_id: user.id)
    if relation.nil?
      Relationship.create(follower_id: self.id, followee_id: user.id)
    else
      relation.destroy
    end
  end

  def like(object)
    if object.class.name == "Post"
      if liked_posts.include?(object)
        liked_posts.destroy(object)
      else
        liked_posts << object
      end
    else
      if liked_comments.include?(object)
        liked_comments.destroy(object)
      else
        liked_comments << object
      end
    end
  end
end
