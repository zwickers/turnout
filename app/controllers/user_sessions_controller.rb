# app/controllers/user_sessions_controller.rb
class UserSessionsController < ApplicationController
  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to "/classes"
    else
      flash[:alert] = 'Login failed'
      redirect_to "/login"
    end
  end

  def destroy
    logout
    redirect_to root_url
  end

  def new
  end
end