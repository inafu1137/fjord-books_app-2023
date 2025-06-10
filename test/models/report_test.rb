# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  fixtures :users, :reports

  test '#editable? returns true if user is owner' do
    report = reports(:report_one)
    user = users(:user_one)
    assert report.editable?(user)
  end

  test '#editable? returns false if user is not owner' do
    report = reports(:report_one)
    user = users(:user_two)
    assert_not report.editable?(user)
  end

  test '#created_on returns the date part of created_at' do
    report = reports(:report_one)
    fixed_time = Time.zone.local(2023, 12, 31, 23, 59, 59)
    report.created_at = fixed_time
    report.save!

    assert_equal fixed_time.to_date, report.created_on
  end

  test 'save_mentions adds new mentions' do
    author = users(:user_one)  # test/fixtures/users.yml にあるユーザーを指定
    mentioned_report = Report.create!(user: author, title: 'Mentioned', content: 'Hello')

    report = Report.new(user: author, title: 'Main report')
    report.content = "これはメンションです → http://localhost:3000/reports/#{mentioned_report.id}"
    report.save!

    assert_includes report.mentioning_reports.map(&:id), mentioned_report.id
  end

  test 'save_mentions removes old mentions' do
    author = users(:user_one)
    mentioned_report = Report.create!(user: author, title: 'Mentioned', content: 'Hello')

    report = Report.create!(user: author, title: 'Main', content: "http://localhost:3000/reports/#{mentioned_report.id}")
    report.content = 'メンション削除済み'
    report.save!
    report.reload

    assert_empty report.mentioning_reports
  end

  test 'save_mentions updates changed mentions' do
    author = users(:user_one)
    mentioned1 = Report.create!(user: author, title: 'Mentioned 1', content: 'Hello')
    mentioned2 = Report.create!(user: author, title: 'Mentioned 2', content: 'Hi')

    report = Report.create!(user: author, title: 'Main', content: "→ http://localhost:3000/reports/#{mentioned1.id}")
    report.content = "→ http://localhost:3000/reports/#{mentioned2.id}"
    report.save!
    report.reload

    assert_not_includes report.mentioning_reports.map(&:id), mentioned1.id
    assert_includes report.mentioning_reports.map(&:id), mentioned2.id
  end
end
