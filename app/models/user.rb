class User < ApplicationRecord
  has_many :microposts, dependent: :destroy

  has_many :relationships, foreign_key: 'follower_id',
                           dependent: :destroy

  has_many :following, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: 'followed_id',
                                   class_name: 'Relationship', dependent: :destroy

  has_many :followers, through: :reverse_relationships,
                       source: :follower

  has_secure_password

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,
            presence: true,
            length: { maximum: 50 }

  validates :email,
            presence: true,
            format: { with: EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password, length: { within: 6..40 }, allow_nil: true

  def self.authenticate(email, password)
    user = find_by(email: email)
    user&.authenticate(password) || nil
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_column(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  attr_accessor :remember_token

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def following?(followed)
    relationships.find_by(followed_id: followed)
  end

  def follow!(followed)
    relationships.create!(followed_id: followed.id)
  end

  def unfollow!(followed)
    relationships.find_by(followed_id: followed).destroy
  end

  def feed
    Micropost.from_users_followed_by(self)
  end
end
