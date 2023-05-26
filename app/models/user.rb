class User < ApplicationRecord
  enum role: [:user, :seller, :admin]
  has_secure_password
  has_one_attached :avatar
  has_one_attached :profile_header
  after_initialize :set_default_role, :if => :new_record? 
  after_create :set_default_tag, :if => :persisted? 
  #belongs_to
  #has_many
  has_many :auth_tokens, dependent: :delete_all
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likeables, dependent: :destroy
  has_many :liked_posts, through: :likeables, source: :likeable, source_type: 'Post'
  has_many :liked_comments, through: :likeables, source: :likeable, source_type: 'Comment'
  has_many :messages, dependent: :destroy
  has_many :room_members, dependent: :destroy
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

  #validates
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "должен быть валидным email адресом" }
  validates :bio, length: { maximum: 1000, message: "не может превышать 1000 символов" }, allow_nil: true, on: :update
  validates :phone_number, format: { with: /\A\+7\d{10}\z/, message: "должен содержать только цифры" }, uniqueness: true,  allow_nil: true, on: :update
  validates :tag, format: { with: /\A(?!\d+$)[a-zA-Z0-9]{1,24}\z/, message: "не может состоять только из цифр и должен содержать не более 24 символов" }, uniqueness: true, allow_nil: true, on: :update
  validates :name, length: { maximum: 24, message: "не может превышать 24 символа" }, allow_nil: true, on: :update
  validates :role, presence: true

  PASSWORD_FORMAT = /\A
    (?=.*\d)           # должна быть хотя бы одна цифра
    (?=.*[a-z])        # должна быть хотя бы одна строчная буква
    (?=.*[A-Z])        # должна быть хотя бы одна заглавная буква
    (?=.*[[:^alnum:]]) # должен быть хотя бы один спецсимвол
    .{8,30}            # должен быть не менее 8 и не более 30 символов в длину
  \z/x
  validates :password, presence: true, length: { minimum: 8, maximum: 30 }, format: { with: PASSWORD_FORMAT }, if: :pass_updating?
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
  private
  def set_default_role
    self.role ||= :user
  end
  #есть уязвимость надо переобдумать
  def set_default_tag
    self.update_column(:tag, "#{self.id}")
  end

  def pass_updating?
    password_digest_changed?
  end
end
