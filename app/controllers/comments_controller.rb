# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: :destroy
  before_action :authorize_user!, only: :destroy

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      redirect_to @commentable, notice: 'コメントを投稿しました'
    else
      redirect_to @commentable, alert: 'コメントの投稿に失敗しました'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    authorize_user!
  end

  def update
    @comment = Comment.find(params[:id])
    authorize_user!
    if @comment.update(comment_params)
      redirect_to @comment.commentable, notice: 'コメントを更新しました'
    else
      render :edit
    end
  end

  def destroy
    authorize_user!
    @comment.destroy!
    redirect_to @comment.commentable, notice: 'コメントを削除しました'
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_user!
    redirect_to @comment.commentable, alert: '権限がありません' unless @comment.user == current_user
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    if params[:report_id]
      Report.find(params[:report_id])
    elsif params[:book_id]
      Book.find(params[:book_id])
    else
      raise ActiveRecord::RecordNotFound, 'コメントの対象が見つかりません'
    end
  end
end
