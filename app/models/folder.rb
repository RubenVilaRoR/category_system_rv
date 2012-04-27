class Folder < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :organization
  has_many :categories
  has_and_belongs_to_many :users
  
  validates_presence_of :name
  validates_presence_of :organization
  validates_uniqueness_of :name, scope: :organization_id

  attr_accessible :name, :use_privacy, :user_tokens
  
  friendly_id :name, use: :slugged
  
  attr_reader :user_tokens
  
  def user_tokens=(ids)
    self.user_ids = ids.split(',')
  end
  
  def check_permission(user)
    return true if !self.use_privacy? || (user.admin? && user.organization == self.organization)
    
    self.users.where(['users.id = ?', user]).count > 0
  end
  
end
