class CreateForumArticles < ActiveRecord::Migration
  def change
    create_table :forum_articles do |t|
      t.integer :forum_topic_flag
      t.integer :forum_parent_id
      t.string :forum_title
      t.text :forum_body
      t.integer :user_id
      t.string :forum_permalink
      t.integer :forum_category_id
      t.integer :forum_hit

      t.timestamps null: false
    end
  end
end
