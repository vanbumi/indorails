module Forum::RootHelper
  
  def last_reply_user_nick_name(forum_article_id)
    @jum = VForumReply.where('forum_parent_id = ?',forum_article_id).count
    
    if @jum > 0
      @last = VForumReply.where('forum_parent_id = ?',forum_article_id).order('id desc').limit(1).take
      "Last reply by "+@last.nick_name
    else
      ""
    end
  end
  
  
  def popular_topics
    @pops = VForumTopic.all.order('reply_count desc').limit(5)
    
    daftar = '<ul class="list-group">'
    @pops.each do |pop|
      daftar = daftar+'<li class="list-group-item"><a href="/forum/'+pop.forum_cat_slug+'/'+pop.id.to_s+'/'+pop.forum_permalink+'">'+pop.forum_title+'</a></li>'
    end
    
    @x = daftar+'</ul>'
    
    @x
  end
end