class CreateVForumTopics < ActiveRecord::Migration
  
  def change
    self.connection.execute %Q( 
			CREATE VIEW v_forum_topics AS 
			select
        fa.id,
				fa.forum_title,
        fa.forum_body,
				fa.user_id,
          mem.email,
          mem.full_name,
          mem.nick_name,
        fa.forum_permalink,
        fa.forum_category_id,
          fac.forum_cat_name,
          fac.forum_cat_description,
          fac.forum_cat_slug,
          fac.forum_cat_count,
        fa.forum_hit,
          (select count(*) from forum_articles where forum_parent_id = fa.id and forum_topic_flag = 0) as reply_count,
				fa.created_at,
				fa.updated_at
			from
				forum_articles fa
					left join forum_categories fac on fa.forum_category_id = fac.id
          left join users mem on fa.user_id =  mem.id
      where
        fa.forum_topic_flag = 1;
	 	)
  end
end
