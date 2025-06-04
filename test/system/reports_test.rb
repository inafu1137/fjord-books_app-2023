# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @user = users(:user_one)
    @report = reports(:report_one)
  end

  # ログイン用ヘルパーメソッド（必要に応じて）
  def login_as(user)
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password123'
    click_on 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    login_as(@user)
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'user can login and create report' do
    login_as(@user)

    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'Test Report Title'
    fill_in '内容', with: 'This is a test report content.'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text 'Test Report Title'
  end

  test 'user can edit own report' do
    login_as(@user)

    visit report_url(@report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: 'Updated Title'
    fill_in '内容', with: 'Updated content'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'Updated Title'
  end

  test 'user can destroy own report' do
    login_as(@user)

    visit report_url(@report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    refute_text @report.title
  end
end
