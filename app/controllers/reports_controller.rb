# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    @reports = Report.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @report = Report.new
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      redirect_to @report, notice: '日報が作成されました'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @report.update(report_params)
      redirect_to @report, notice: '日報が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_path, notice: '日報が削除されました'
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :body)
  end

  def authorize_user!
    redirect_to reports_path, alert: '権限がありません' unless @report.user == current_user
  end
end
