class User::AvatarController < ApplicationController
  def create
    current_user.avatar = user_params[:avatar]
    current_user.save(validate: false)

    redirect_to user_profile_path
  end

  def destroy
    current_user.avatar = nil
    current_user.save(validate: false)

    redirect_to user_profile_path
  end

  private

  def user_params
    params.require(:user).permit(
      :avatar
    )
  end
end
