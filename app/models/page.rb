class Page < ActiveRecord::Base
  attr_accessible :parent_id, :template_id, :title, :body, :preview, :path, :visible, :update_by,
                  :home_page
                  
  has_many :sub_pages, :class_name => 'Page', :foreign_key => :parent_id
  has_many :images, :as => :attachable
  
  validates :title, :body, :path, :presence => true
end
