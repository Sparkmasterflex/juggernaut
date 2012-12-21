class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :attachable_id
      t.string  :attachable_type
      t.string  :title
      t.text    :caption
      t.integer :item_order
      t.boolean :visible

      t.timestamps
    end
  end
end
