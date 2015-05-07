class NotificationsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	before_action :authenticate_admin!
	layout 'user'

  def new
  	@notification = Notification.new
  end

  def create
  	@notification = Notification.new(notification_params)
  	@notification.admin_id = current_admin.id
	@notifications = Notification.all

	if @notification.save
		@notification.save
		if @notification.live == true
			@notifications.each do |notification|
				if notification != @notification
					notification.live = false
					notification.save
				end
			end
		end
		redirect_to notifications_path
	else
		render 'new'
	end
  end

  def edit
  	@notification = Notification.find(params[:id])
  end

  def update
  	@notification = Notification.find(params[:id])
	@notifications = Notification.all

	if @notification.update(notification_params)
		if @notification.live == true
			@notifications.each do |notification|
				if notification != @notification
					notification.live = false
					notification.save
				end
			end
		end

		redirect_to notifications_path
	else
		render 'edit'
	end
  end

  def index
  	@notifications = Notification.order('created_at DESC').paginate(:page => params[:page], :per_page => 6)
  end

  def destroy
  		@notification = Notification.find(params[:id])
		@notification.destroy

		flash[:notice] = "Successfully deleted notification."
		redirect_to notifications_path
  end

  private
  	def notification_params
  		params.require(:notification).permit(:headline, :content, :live)
	end
end
