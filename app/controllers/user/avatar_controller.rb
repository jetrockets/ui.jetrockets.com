class User::AvatarController < ApplicationController
  def create
    current_user.image = user_params[:image]
    current_user.save(validate: false)

    redirect_to edit_user_profile_path
  end

  def destroy
    current_user.image = nil
    current_user.save(validate: false)

    redirect_to edit_user_profile_path
  end

  private

  def user_params
    params.require(:user).permit(
      :image
    )
  end
end
