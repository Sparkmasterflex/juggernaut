class Image < ActiveRecord::Base
  TOKEN_URL = '8ca6fcbf1876f29da54c8e6a0c3e4238'
  
  attr_accessible :attachment, :attachable_id, :attachable_type, :title, :caption
  
  belongs_to :attachable, :polymorphic => true
  
  has_attached_file :attachment, :styles => { :large => "400x400>", :thumb => "80x80>"}
  
  def as_json options={}
    attr = {}
    attributes.each do |key, value|
      attr.merge!({key => value}) unless [:created_at, :updated_at].include?(key)
      attr.merge!({key => value.strftime("%m/%d/%Y")}) if [:created_at, :updated_at].include?(key)
    end
    
    attr.merge!({
      :thumb => attachment.url(:thumb),
      :large => attachment.url(:large),
      :uploaded_at => created_at.strftime("%m/%d/%Y")
    })
  end
end
