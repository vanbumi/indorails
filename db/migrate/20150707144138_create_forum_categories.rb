class CreateForumCategories < ActiveRecord::Migration
  def change
    create_table :forum_categories do |t|
      t.string :forum_cat_name
      t.text :forum_cat_description
      t.string :forum_cat_slug
      t.integer :forum_cat_count

      t.timestamps null: false
    end
  end
end
