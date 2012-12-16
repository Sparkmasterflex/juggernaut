class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string  :title
      t.text    :body
      t.integer :progress, :default => 0
      t.string  :client
      t.string  :url
      t.date    :start_date
      t.string  :technology
      t.boolean :featured, :default => false
      t.boolean :visible, :default => false
      t.integer :update_by

      t.timestamps
    end
  end
end
