class Project < ActiveRecord::Base
  attr_accessible :title, :body, :progress, :client, :url, :start_date,
                  :technology, :featured, :visible, :update_by
  
  has_many :images, :as => :attachable
  
  validates :title, :body, :presence => true
  validates :title, :uniqueness => true
end
