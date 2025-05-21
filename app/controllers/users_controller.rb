# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.with_attached_icon.order(:id).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィール情報を更新しました'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :postal_code, :address, :self_introduction, :icon)
  end
end
