class Shulte  < ActiveRecord::Base
  validates :time,  presence: true
  validates :mistakes,  presence: true
end
