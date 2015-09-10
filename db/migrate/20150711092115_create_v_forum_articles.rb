class CreateVForumArticles < ActiveRecord::Migration
  def change
    self.connection.execute %Q( 
			CREATE VIEW v_forum_articles AS 
			select
        fa.id,
        fa.forum_topic_flag,
        fa.forum_parent_id,
        fa.forum_title,
        fa.forum_body,
				fa.member_id,
          mem.email,
          mem.full_name,
          mem.nick_name,
        fa.forum_permalink,
        fa.forum_category_id,
          fac.forum_cat_name,
          fac.forum_cat_description,
          fac.forum_cat_slug,
          fac.forum_cat_count,
          concat(fa.forum_title,' ',fa.forum_body) as forum_article_all,
				fa.created_at,
				fa.updated_at
			from
				forum_articles fa
					left join forum_categories fac on fa.forum_category_id = fac.id
          left join members mem on fa.member_id =  mem.id;
	 	)
  end
end
