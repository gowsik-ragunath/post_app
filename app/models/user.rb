class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

################################ASSOCIATION######################################################################
  has_many :posts, dependent: :destroy
  has_and_belongs_to_many :post_reads ,class_name:'Post', join_table: :posts_users_reads
  has_many :comments, dependent: :destroy
  has_many :user_comment_ratings
  has_many :rated_comments , through: :user_comment_ratings , source: :comment , dependent: :destroy
  has_many :comment_ratings , through: :user_comment_ratings , source: :rating , dependent: :destroy
end