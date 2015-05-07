class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   # For Paperclip
  has_attached_file :avatar, :styles => { :medium => "200x200#", :thumb => "32x32#" }, :default_url => "/images/:style/missing.png", :url => ":s3_domain_url", :path => "/:class/:attachment/:id_partition/:style/:filename"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :videos
  has_many :notifications
end
