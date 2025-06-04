# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  test '#name_or_email returns name if present' do
    user = users(:user_one)
    assert_equal 'userone', user.name_or_email
  end

  test '#name_or_email returns email if name is blank' do
    user = users(:user_two)
    assert_equal user.email, user.name_or_email
  end
end
