class AdminsController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_admin!, :except => [:index, :show, :update]
  layout 'user'

  def show
    @admin = Admin.find(params[:id])
  end

  def update
  	# authorize! :update, @admin
    respond_to do |format|
      if @admin.update(admin_params)
        sign_in(@admin == current_admin ? @admin : current_admin, :bypass => true)
        format.html { redirect_to @admin, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }

      else
        format.html { render action: 'edit' }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  	@admin = Admin.find(params[:id])
	  @admin.destroy
		   
	 redirect_to root
  end

  private
    def set_admin
      @admin = Admin.find(params[:id])
    end

    def admin_params
      accessible = [ :fname, :lname, :email, :avatar ]
      accessible << [ :password, :password_confirmation ] unless params[:admin][:password].blank?
      params.require(:admin).permit(accessible)
    end
end
