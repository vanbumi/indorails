class ClippingsController < ApplicationController
  
  def index
    @datas = Clipping.all.order('created_at DESC').paginate(page: params[:page], per_page: app_set('article_size').to_i)
  end
  
end
