class Notification < ActiveRecord::Base
	validates_presence_of :headline
	validates_presence_of :content
	validates_length_of :headline, maximum: 30
	validates_length_of :content, maximum: 75
	belongs_to :admin
end
