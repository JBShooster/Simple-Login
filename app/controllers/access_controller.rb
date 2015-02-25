class AccessController < ApplicationController
  before_action :prevent_login_signup, only: [:signup, :login]

  def signup
    @user = User.new()
  end

  def login
  end

  def home

  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Goodbye!"
    redirect_to login_path
  end

  def create
    @user = User.create(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to login_path
    else
      render :signup
    end
  end


  def attempt_login
    if params[:username].present? && params[:password].present?
      found_user = User.where(username: params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
          if authorized_user
            session[:user_id] = authorized_user.id
            flash[:success] = "You are now logged in!"
            redirect_to home_path
          else
            flash.now[:notice] = "ACCESS DENIED!"
            render :login    
          end
      else
        flash.now[:notice] = "ACCESS DENIED!"
        render :login
      end
    else
      flash.now[:notice] = "ACCESS DENIED!"
      render :login
    end
  end

  private
    def prevent_login_signup
      if session[:user_id]
        redirect_to home_path
      end
    end
    def user_params
      params.require(:user).permit(:username, :password)
    end
end
