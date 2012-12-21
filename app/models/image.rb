class Image < ActiveRecord::Base
  TOKEN_URL = '8ca6fcbf1876f29da54c8e6a0c3e4238'
  
  attr_accessible :attachment, :attachable_id, :attachable_type, :title, :caption, :item_order, :visible
  
  belongs_to :attachable, :polymorphic => true
  
  has_attached_file :attachment, :styles => { :large => "400x400>", :thumb => "80x80>"}
  
  def self.reorder current, from, to
    from = from.to_i
    to = to.to_i
    others = where(:attachable_id => current.attachable_id, :attachable_type => current.attachable_type).order(:item_order).reject { |img| img == current }
    
    if current.item_order > to
      others.reject! { |img| img.item_order > current.item_order || img.item_order < to }
    else
      others.reject! { |img| img.item_order < current.item_order || img.item_order > to }
    end
    
    current.update_attribute 'item_order', to
    others.each do |o|
      new_pos = from > to ?
        o.item_order + 1 :
          o.item_order - 1
      o.update_attribute 'item_order', new_pos
    end
    
    current
  end
  
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
