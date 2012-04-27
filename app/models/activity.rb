class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :organization
  
  attr_accessible :date, :info, :tags, :attachment, :category_id, :priority
  
  validates_presence_of :user
  validates_presence_of :category
  validates_presence_of :date
  validates_presence_of :info
  
  mount_uploader :attachment, ActivityAttachmentUploader
end
