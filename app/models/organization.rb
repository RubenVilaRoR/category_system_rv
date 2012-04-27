class Organization < ActiveRecord::Base
  attr_accessible :name
  
  validates_presence_of :name
  
  has_many :users, dependent: :destroy
  has_many :pay_periods, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :folders
end
