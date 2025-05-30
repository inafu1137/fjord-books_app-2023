# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :outgoing_mentions, class_name: 'Mention', foreign_key: :mentioner_id, inverse_of: :mentioner, dependent: :destroy
  has_many :mentioning_reports, through: :outgoing_mentions, source: :mentionee

  has_many :incoming_mentions, class_name: 'Mention', foreign_key: :mentionee_id, inverse_of: :mentionee, dependent: :destroy
  has_many :mentioned_reports, through: :incoming_mentions, source: :mentioner

  after_save :update_mentions

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def update_mentions
    outgoing_mentions.destroy_all
    mentioned_ids = extract_report_ids_from_content.map(&:to_i).uniq - [id]
    mentioning_reports << Report.where(id: mentioned_ids)
  end

  def extract_report_ids_from_content
    content.to_s.scan(%r{\bhttp://localhost:3000/reports/(\d+)\b}).flatten.uniq
  end
end
