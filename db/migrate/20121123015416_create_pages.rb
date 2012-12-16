class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer  :parent_id
      t.integer  :template_id
      t.string   :title
      t.text     :preview
      t.text     :body
      t.text     :path
      t.integer  :update_by
      t.boolean  :home_page, :default => false
      t.boolean  :visible, :default => false

      t.timestamps
    end
  end
end
