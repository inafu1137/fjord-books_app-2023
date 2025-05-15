# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :icon
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validate :icon_format

  private

  def icon_format
    return unless icon.attached?

    return if icon.content_type.in?(%w[image/jpeg image/png image/gif])

    errors.add(:icon, 'はjpg, png, gif形式のみアップロード可能です')
  end
end
