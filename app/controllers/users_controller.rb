class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :screen_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
      if user_signed_in?
        @currentUserUserRoom = UserRoom.where(user_id: current_user.id)
        @userUserRoom = UserRoom.where(user_id: @user.id)
        unless @user.id == current_user.id
          @currentUserUserRoom.each do |cu|
            @userUserRoom.each do |u|
              if cu.room_id == u.room_id
                @haveRoom = true
                @roomId = cu.room_id
              end
            end
          end
          unless @haveRoom
            @room = Room.new
            @user_room = UserRoom.new
          end
        end
      end
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private
    def user_params
       params.require(:user).permit(:name, :introduction, :profile_image)
    end

    def screen_user
      unless params[:id].to_i == current_user.id
        redirect_to user_path(current_user)
      end
    end

end

