class Video < ActiveRecord::Base
	include AutoHtml

	validates_presence_of :title
	validates_presence_of :description
	validates_presence_of :url
	belongs_to :admin
	acts_as_taggable
	acts_as_taggable_on :categories

	auto_html_for :url do
		html_escape
		image
		youtube(:width => "100%", :height => "75%")
		link :target => "_blank", :rel => "nofollow"
		simple_format
	end

	def self.search(search)
	  if search
	    where('title ILIKE :search OR description ILIKE :search', search: "%#{search}%")
	    #where('description ILIKE ?', "%#{search}%")
	    #where('title ILIKE ?', "%#{search}%")
	  end
	end
end
