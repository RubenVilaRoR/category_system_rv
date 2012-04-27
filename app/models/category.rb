class Category < ActiveRecord::Base
  extend FriendlyId
  belongs_to :organization
  belongs_to :folder
  has_many :activities, dependent: :destroy
  has_and_belongs_to_many :users # user that can access the category if self.use_privacy?
  
  attr_accessible :name, :color, :group, :user_tokens, :use_privacy
  
  validates_presence_of :name
  validates_presence_of :organization
  validates_uniqueness_of :name, scope: :organization_id, message: 'already exists' 
  validates_length_of :color, maximum: 7
  
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
