class Adm::ArticlesController < ApplicationController

  before_action :authenticate_user!

  layout "adm_layout"

  # Displaying articles
  # ==== Path
  # get /adm/articles
  def index
    @q = params[:q]
    
    if(params[:rows])
      @rows = params[:rows].to_i
    else
      @rows = 10
    end
    
    # order field
    if(params[:of])
      @of = params[:of]
    else
      @of = 'created_at'
    end
    
    # order direction
    if(params[:od])
      @od = params[:od]
    else
      @od = 'DESC'
    end

    if @q
      @q.gsub!(/[^0-9a-z ]/i, '')

      @arr = @q.split(" ")

      @qa = ""
      @arr.each { |q| @qa = @qa+"article_all like '%"+q+"%' and "; }

      @articles = VArticle.where(@qa[0..(@qa.length - 5)]).order(@of+' '+@od).paginate(page: params[:page], per_page: @rows)
    else
      @articles = VArticle.all.order(@of+' '+@od).paginate(page: params[:page], per_page: @rows)
    end
  end # index

  
  # Showing new article page
  # ==== Path
  # get /adm/articles/new
  def new
    @article = Article.new
    @categories = Category.all.order('cat_name ASC')		
  end # new

  
  # Insert a new article into database
  # ==== Path
  # post /adm/articles
  def create
    @article = Article.new(article_params)
    @article.article_type = 'Article'
    @article.article_vcount = 0
    @article_save = @article.save

    #if article has been saved
    if @article_save
      if params[:category]
        if params[:category][:category_id]
          @cats = params[:category][:category_id]
          @cats.each do |cat|
            @artcat = ArticleCategory.new
            @artcat.article_id = @article.id
            @artcat.category_id = cat
            @artcat.save
          end
        end	
      end
    end

    if @article_save
      redirect_to adm_articles_path
    else

      @categories = Category.all
      render 'new'
    end 
  end # create

  
  # Showing article edit page
  # ==== Path
  # get /adm/articles/:id/edit
  def edit
    id = params[:id].to_i
    @page = params[:page].to_i

    @article = Article.find(id)
    @categories = Category.all.order('cat_name ASC')
  end

  # Update an article
  # ==== Path
  # patch /adm/articles/:id
  def update
    id = params[:id].to_i
    @page = params[:page].to_i

    @article = Article.find(id)
    @article_update = @article.update(article_params)

    #delete category by article_id and create new category to this article
    ArticleCategory.where(:article_id => id).destroy_all

    #insert all of categories
    if params[:category]
      if params[:category][:category_id]
        @cats = params[:category][:category_id]
        @cats.each do |cat|
          @artcat = ArticleCategory.new
          @artcat.article_id = id
          @artcat.category_id = cat
          @artcat.save
        end
      end	
    end #params[:category]

    if @article_update
      redirect_to adm_articles_path(:page => @page)
    else
      # if it doesn't save, this object need to cast

      @categories = Category.all
      render 'edit'
    end 
  end # def update

  # Delete an article
  # ==== Path
  # delete /adm/articles/:id
  def destroy
    @page = params[:page].to_i
    # find article id
    @art = Article.find(params[:id])

    #destroy article_category
    ArticleCategory.where('article_id = ?',@art.id).destroy_all

    #destroy article based on id
    @art.destroy

    redirect_to adm_articles_path(:page => @page)
  end #def destroy


  private
  def article_params
    params.require(:article).permit(:title, :body, :permalink, :publish_status, :publish_visibility, :excerp, :author_id, :feat_img)
  end

end