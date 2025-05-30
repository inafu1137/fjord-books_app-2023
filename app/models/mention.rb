# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mentioner, class_name: 'Report'
  belongs_to :mentionee, class_name: 'Report'
end
