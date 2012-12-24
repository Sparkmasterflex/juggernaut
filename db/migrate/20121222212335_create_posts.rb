class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string  :title
      t.text    :preview
      t.text    :body
      t.integer :category
      t.integer :author_id
      t.boolean :visible
      
      t.timestamps
    end
  end
end
