class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :body
      t.text :author
      t.boolean :published

      t.timestamps null: false
    end
  end
end
