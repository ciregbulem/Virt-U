class Notification < ActiveRecord::Base
	validates_presence_of :headline
	validates_presence_of :content
	validates_length_of :headline, maximum: 50
	validates_length_of :content, maximum: 140
	belongs_to :admin
end
