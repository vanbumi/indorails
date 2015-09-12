class Forum::RootController < ApplicationController
  
  # get forum<br>
  # Showing root for forum
  def index
    @forum_categories = ForumCategory.all
    @topics = VForumTopic.all.order('id desc').paginate(page: params[:page], per_page: 20)
    
    # Untuk mengaktifkan head
    @head_active = "head_forum_all"
    
    # SEO
    @dynamic_title = 'Forum'
  end
  
  # get 'search', to: 'root#search'
  def search
    @q = params[:q]

    @q.gsub!(/[^0-9a-z ]/i, '')

    @arr = @q.split(" ")

    @qa = ""
    @arr.each do |q|
      @qa = @qa+"forum_article_all like '%"+q+"%' and "
    end
    
    @forum_categories = ForumCategory.all
    
    @forum_articles = VForumArticle.where(@qa[0..(@qa.length - 5)]).paginate(page: params[:page], per_page: 20)
    
    @head_active = "head_forum_all"
    
    # SEO
    @dynamic_title = 'Forum Search'
  end
  
  # get ':forum_cat_slug'<br>
  def per_category
    @forum_cat_slug = params[:forum_cat_slug]
    
    @forum_categories = ForumCategory.all
    
    @topics = VForumTopic.where(forum_cat_slug: @forum_cat_slug).paginate(page: params[:page], per_page: 20)
    
    @head_active = "head_forum_"+@forum_cat_slug
    
    # SEO
    @dynamic_title = 'Forum'
    
    render 'forum/root/index'
  end
  
  # get forum/new_topic<br>
  # Showing new topic for forum
  def new_topic
    if(current_user)
      @forum_article = ForumArticle.new
      @forum_categories = ForumCategory.all.order('forum_cat_name')
    else
      redirect_to '/forum'
    end
  end
  
  # post forum/new_topic_save<br>
  # Save new topic
  def new_topic_save
    if current_user
      @fa                     = ForumArticle.new
      @fa.forum_topic_flag    = 1
      @fa.forum_title         = params[:forum_article][:forum_title]
      @fa.forum_permalink     = params[:forum_article][:forum_title].downcase.gsub!(/\W/,'-')
      @fa.forum_body          = params[:forum_article][:forum_body]
      @fa.forum_category_id   = params[:forum_article][:forum_category_id]
      @fa.user_id             = current_user.id
      @fa_save                = @fa.save
      
      @vfa = VForumTopic.where(id: @fa.id).take
      redirect_to "/forum/#{@vfa.forum_cat_slug}/#{@fa.id}/#{@fa.forum_permalink}"
    else
      @forum_article = ForumArticle.new
      @forum_categories = ForumCategory.all.order('forum_cat_name')
      render 'new_topic'
    end
    
  end
  
  
  # get ':id/single_topic_ajax', to: 'root#single_topic_ajax' # ajax
  def single_topic_ajax
    @id = params[:id].to_i
    @topic = VForumTopic.where('id = ?',@id).take
    render partial: 'forum/root/inside/topic'
  end
  
  # get ':id/edit_topic', to: 'root#edit_topic'
  def edit_topic
    # edit topic hanya dapat diakses oleh member
    if(current_user)
      @id = params[:id].to_i
      @forum_article = ForumArticle.find(@id)
      render partial: 'edit_topic'
    else
      render inline: 'Please login or sign-up'
    end
  end
  
  # patch ':id/edit_topic_post', to: 'root#edit_topic_post' # ajax
  # *Proses*
  # * Pastikan yang mengedit adalah user itu sendiri
  def edit_topic_post
    if current_user 
      @id = params[:id].to_i
      @forum_article = ForumArticle.find(@id)
      
      if current_user.id == @forum_article.user_id
        @forum_article.forum_title = params[:forum_article][:forum_title]
        @forum_article.forum_body = params[:forum_article][:forum_body]
        @forum_article.save
        
        render inline: 'success'
      else
        render inline: "fail"
      end
    else 
      render inline: "fail"
    end
  end
  
  # get ':id/single_reply_ajax', to: 'root#single_reply_ajax' # ajax
  def single_reply_ajax
    @id = params[:id].to_i
    @reply = VForumReply.where('id = ?',@id).take
    render partial: 'forum/root/inside/reply'
  end
  
  # get ':forum_cat_slug/:id/:forum_permalink'<br>
  # Disini pastinya juga ditampilkan reply dari forum tersebut
  def one_topic
    @forum_cat_slug   = params[:forum_cat_slug]
    @id               = params[:id].to_i
    @forum_permalink  = params[:forum_permalink]
    
    if params[:reply]
      @reply = params[:reply].to_i
    end
    
    @forum_categories = ForumCategory.all
    
    @topic = VForumTopic.where(id: @id).take
    
    @head_active = "head_forum_"+@forum_cat_slug
    
    @replies = VForumReply.where('forum_parent_id = ?',@id).paginate(page: params[:page], per_page: 20)
    
  end
  
  # post ':id/reply_post', to: 'root#reply_post'
  def reply_topic
    @id = params[:id].to_i
    @body = params[:body] # bersihkan input dari script
    
    @fnx = ForumArticle.new
    @fnx.forum_topic_flag = 0
    @fnx.forum_parent_id = @id
    @fnx.forum_body = secure_body(@body)
    @fnx.user_id = current_user.id
    @fnx.save
    
    # kembalikan
    @tbx = VForumTopic.where('id = ?',@id).take
    
    redirect_to '/forum/'+@tbx.forum_cat_slug+'/'+@id.to_s+'/'+@tbx.forum_permalink
  end
  
  # get ':id/edit_reply', to: 'root#edit_reply' # ajax
  def edit_reply
    @id = params[:id].to_i
    @reply = VForumReply.where('id = ?',@id).take
    render partial: 'edit_reply'
  end
  
  # patch ':id/edit_reply_patch', to: 'root#edit_reply_patch' # ajax
  def edit_reply_patch
    if current_user
      @id = params[:forum_article][:id].to_i
      @body = params[:forum_article][:forum_body]
      
      # mencari forum
      @forum_article = ForumArticle.find(@id)
      @forum_article.forum_body = secure_body(@body)
      @forum_article.save
      
      render inline: 'success'
    else
      render inline: 'fail'
    end
  end
  
  # delete ':id/reply_delete', to: 'root#reply_delete' # ajax
  def reply_delete
    if current_user
      @id = params[:id].to_i
      
      # periksa pemilik
      @periksa = ForumArticle.find(@id)
      
      if @periksa.user_id == current_user.id
        @periksa.destroy
        render inline: 'success'
      else
        render inline: 'fail'
      end
    else
      render inline: 'fail'
    end
  end
  
  # delete ':id/delete_topic', to: 'root#delete_topic'<br>
  # *Proses*<br>
  # * Pastikan user sudah login
  # * Pastikan user yang mendelete adalah user yang mempunyai topic itu sendiri
  # * Jika user yang bersangkutan, maka;
  # * Delete terlebih dahulu reply dari topic
  # * Setelah itu, baru delete topic nya
  def delete_topic
    if current_user
      @id = params[:id].to_i
      @fa = ForumArticle.find(@id)
      
      if @fa.user_id == current_user.id
        # delete terlebih dahulu reply-nya
        ForumArticle.where('forum_parent_id = ?',@id).destroy_all 
        
        # delete topic
        ForumArticle.find(@id).destroy
        
        render inline: 'success'
      else
        render inline: 'fail'
      end
    else
      render inline: 'fail'
    end
  end
  
  
  # ---------------------------------------------- PRIVATE
  private
  def forum_article_params
    params.require(:forum_article).permit(:forum_title, :forum_body, :forum_permalink, :forum_category_id)
  end
  
  # mengamankan post body yang dikirimkan
  def secure_body(body_text)
    body_text.gsub("<script","&lt;script")
  end
  
  # ---------------------------------------------- PRIVATE
end
