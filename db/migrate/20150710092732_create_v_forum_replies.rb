class CreateVForumReplies < ActiveRecord::Migration
  def change
    self.connection.execute %Q( 
			CREATE VIEW v_forum_replies AS 
			select
        fa.id,
        fa.forum_parent_id,
        fa.forum_body,
				fa.user_id,
          mem.email,
          mem.full_name,
          mem.nick_name,
        fa.forum_category_id,
          fac.forum_cat_name,
          fac.forum_cat_description,
          fac.forum_cat_slug,
          fac.forum_cat_count,
				fa.created_at,
				fa.updated_at
			from
				forum_articles fa
					left join forum_categories fac on fa.forum_category_id = fac.id
          left join users mem on fa.user_id =  mem.id
      where
        fa.forum_topic_flag = 0;
	 	)
  end
end
