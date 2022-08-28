class Shulte  < ActiveRecord::Base
  validates :user_id,  presence: true
  validates :time,  presence: true
  validates :mistakes,  presence: true
end
