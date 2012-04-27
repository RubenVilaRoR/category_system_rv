class User < ActiveRecord::Base
  authenticates_with_sorcery!
  belongs_to :organization, counter_cache: true
  has_many :activities, dependent: :destroy
  
  has_and_belongs_to_many :categories # categories that user have permission
  has_and_belongs_to_many :folders # folder that user have permission to
  
  attr_accessor :organization_name
  attr_accessible :username, :name, :group, :active, :email, :password, :password_confirmation, :admin, :organization, as: :admin
  attr_accessible :username, :name, :group, :email, :password, :password_confirmation, :organization_name
  
  validate :organization_name_if_no_organization
  validates_presence_of :name
  validates_presence_of :organization
  validates_presence_of :password, :on => :create
  validates :password, length: { minimum: 5 }, confirmation: true, unless: "password.blank?"
  validates :username, uniqueness: true, presence: true, format: { with: /^[\w\d]+$/ }, length: { minimum: 5 }
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }, uniqueness: true
  
  def organization_name_if_no_organization
    errors.add(:organization_name, "can't be blank") if (organization && organization.name.blank?) && organization_name.blank?
  end
  
  def all_folders
    raise "User does not have organization" unless organization
    self.organization.folders
  end
  
  def permitted_folders
    raise "User does not have organization" unless organization
    self.organization.folders.where('use_privacy = ? OR (folders.id IN (?))', false, self.folders)
  end
  
  def user_folders
    self.admin? ? all_folders : permitted_folders
  end
  
  def all_categories
    raise "User does not have organization" unless organization
    self.organization.categories
  end
  
  def permitted_categories
    raise "User does not have organization" unless organization
    permitted_folders = self.permitted_folders
    self.organization.categories.joins('LEFT OUTER JOIN folders on folders.id = categories.folder_id').where('(folders.id is NULL OR folders.use_privacy = ? OR folders.id in (?)) AND (categories.use_privacy = ? OR (categories.id IN (?)))', false, permitted_folders, false, self.categories)
  end
  
  def user_categories
    self.admin? ? all_categories : permitted_categories
  end
  
  def all_activities
    raise "User does not have organization" unless organization
    self.organization.activities
  end
  
  def permitted_activities
    raise "User does not have organization" unless organization
    pfolder = self.permitted_folders.pluck(id)
    
    #binding.pry
    self.organization.activities.joins(:category).joins('LEFT OUTER JOIN folders f on f.id = categories.folder_id').where('(f.id IS NULL OR f.use_privacy = ? OR f.id in (?)) AND (categories.use_privacy = ? OR (categories.id IN (?)))', false,  pfolder, false, self.categories)
  end
  
  def user_activities
    self.admin? ? all_activities : permitted_activities
  end
end
