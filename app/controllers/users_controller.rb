class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index, :show, :update]
  layout 'user'

  def index
  	@users = User.paginate(:page => params[:page], :per_page => 3).order('created_at DESC')
  end

  def show
    @user = User.find(params[:id])
    @notification = Notification.find_by live: true
    @categories = ActsAsTaggableOn::Tag.most_used(5)
    @recent_videos = Video.paginate(:page => params[:page], :per_page => 3).order('created_at DESC')
    @client = YouTubeIt::Client.new(:dev_key => "AIzaSyAsenX0SHJuk5JMeP6L8yKz1R9eigG2V0c")
    @found_featured = Video.find_by featured: true
    @featured_video = []
    @featured_video.push(@found_featured)
    @featured_video.push(@client.video_by(@found_featured.url))
  end

  def edit
  	@user = current_user
  end

  def destroy
	 @user = User.find(params[:id])
	 @user.destroy
		   
	 redirect_to users_path
  end

  def update
  	# authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }

      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    current_user.email = current_user.temp_email
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      if current_user.update(user_params)
        @user.skip_reconfirmation! if @user.respond_to?(:skip_confirmation)
        sign_in(current_user, :bypass => true)
        redirect_to current_user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :fname, :lname, :email, :about, :avatar ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
