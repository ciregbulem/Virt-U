class VideosController < ApplicationController
	before_action :authenticate_admin!, :except => [:index, :show]
	layout 'user'

	include AutoHtml

	def new
		@video = Video.new
	end
	
	def create
		@video = Video.new(video_params)
		@video.admin_id = current_admin.id
		@video_client = YouTubeIt::Client.new(:dev_key => ENV["youtube_dev_key"])
		@video.thumbnail = @video_client.video_by(@video.url).thumbnails.first.url
		@videos = Video.all
		if @video.save
			@video.save
			if @video.featured == true
				@videos.each do |video|
					if video != @video
						video.featured = false
						video.save
					end
				end
			end
			redirect_to @video
		else
			render 'new'
		end
	end
	
	def show
		@video = Video.find(params[:id])
		@client = YouTubeIt::Client.new(:dev_key => ENV["youtube_dev_key"])
		@video2 = @client.video_by(@video.url)
	end
	
	def index
		if params[:tag]
			@videos = Video.tagged_with(params[:tag])

		elsif params[:category]
			@videos = Video.tagged_with(params[:category])
		
		elsif params[:search]
	  		@videos = Video.search(params[:search]).order('created_at DESC').paginate(:page => params[:page], :per_page => 6)
  		else
  			@videos = Video.order('created_at DESC').paginate(:page => params[:page], :per_page => 6)
  		end
  		@client = YouTubeIt::Client.new(:dev_key => ENV["youtube_dev_key"])
  		@video_array = []
  		@videos.each do |video|
  			@video_array.push([video,@client.video_by(video.url)])
  		end
  		@admins = Admin.paginate(:page => params[:page], :per_page => 2)
  		@admins = @admins.reverse_order
	end
	
	def edit
		@video = Video.find(params[:id])
	end
	
	def update
		@video = Video.find(params[:id])
		@videos = Video.all

		if @video.update(video_params)
			if @video.featured == true
				@videos.each do |video|
					if video != @video
						video.featured = false
						video.save
					end
				end
			end

			redirect_to @video
		else
			render 'edit'
		end
	end
	
	def destroy
		if current_admin.id == Video.find(params[:id]).admin_id
			@video = Video.find(params[:id])
			@video.destroy

			redirect_to videos_path
		else
			flash[:alert] = "Whoops! You can only delete videos you created."
			redirect_to current_admin
		end
	end
		      
	private
		def video_params
			params.require(:video).permit(:title, :description, :url, :featured, :tag_list, :category_list)
		end
end
