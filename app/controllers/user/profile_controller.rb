class User::ProfileController < ApplicationController
  def show
  end

  def update
    if current_user.update(user_params)
      flash[:success] = t("shared.messages.updated", resource_name: Account.model_name.human)
      redirect_to user_profile_path
    else
      flash.now[:alert] = t("shared.messages.errors")
      render :show, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :avatar
    )
  end
end
