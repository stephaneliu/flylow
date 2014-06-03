class UsersController < ApplicationController

  load_and_authorize_resource

  def index
  end

  def show
  end

  def update
    if @user.update_attributes(user_params(:admin))
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end
    
  def destroy
    # user = User.find(params[:id])
    unless @user == current_user
      @user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  private

  def user_params(admin=false)
    params.require(:user).require(:name, :email, :password, :password_confirmation, :remember_me, :role_ids)
  end
end
