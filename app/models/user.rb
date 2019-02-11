class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, class_name: 'Post', dependent: :destroy
  has_and_belongs_to_many :post, join_table: :posts_users_reads
  has_many :comments,class_name: 'Comment' ,dependent: :destroy
  has_many :user_comment_ratings
  has_many :comment, through: :user_comment_ratings
end
