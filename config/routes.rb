Rails.application.routes.draw do

  devise_for :users

	#---------------------------
	root  "landing#index"

  get 'search', to: 'search#index'
  
	get 'galleries', to: 'galleries#index'

	get ':permalink', to: 'article_single#index'

	get 'page/:permalink', to: 'page_single#index'

	get 'category/:permalink', to: 'percategory#index'	

	post 'discuss/send_insert', to: 'discuss#send_insert'
  
  namespace :forum do
    get    'index',                     to: 'root#index'
    get    'search',                to: 'root#search'
    get    'new_topic',             to: 'root#new_topic'
    post   'new_topic_save',        to: 'root#new_topic_save'
    get    ':id/single_topic_ajax', to: 'root#single_topic_ajax' # ajax
    get    ':id/edit_topic',        to: 'root#edit_topic' # ajax
    patch  ':id/edit_topic_post',   to: 'root#edit_topic_post' # ajax
    delete ':id/delete_topic',      to: 'root#delete_topic'
    get    ':id/single_reply_ajax', to: 'root#single_reply_ajax' # ajax
    post   ':id/reply_topic',       to: 'root#reply_topic' # ajax
    get    ':id/edit_reply',        to: 'root#edit_reply' # ajax
    patch  ':id/edit_reply_patch',  to: 'root#edit_reply_patch' # ajax
    delete ':id/reply_delete',      to: 'root#reply_delete' # ajax
    
    get    ':forum_cat_slug', to: 'root#per_category'
    
    get    ':forum_cat_slug/:id/:forum_permalink', to: 'root#one_topic'
  end
  
	#---------------------------

  namespace :adm do
    resources :dashboard
    resources :articles
    resources :categories
    
    resources :media, path: 'media' do
      collection do
        post 'upload'
        get 'edit'
        patch 'update/:id', to: 'media#update'
        delete 'destroy/:id', to: 'media#destroy'
        
        get 'media_win', to: 'media#media_win_index'
        get 'media_win/the_page', to: 'media#media_win_the_page'
      end
    end
    
    resources :discuss do
      collection do
        post 'approve', to: 'discuss#approve'
        post 'disapprove', to: 'discuss#disapprove'
      end
    end
    
    resources :pages
    
    resources :themes do
      collection do
        post 'upload', to: 'themes#upload'
        post 'active/:id', to: 'themes#active'
        delete 'destroy/:id', to: 'themes#destroy'
      end
    end
    
    resources :users
    
    resources :menus do
      collection do
        get 'edit', to: 'menus#edit'
        post 'update', to: 'menus#update'
        post 'update_draft', to: 'menus#update_draft'
        get 'draft_menu_element', to: 'menus#draft_menu_element'
        get 'current_menu_element', to: 'menus#current_menu_element'
        get 'save_menus', to: 'menus#save_menus'
        get 'form_manual', to: 'menus#form_manual'
        post 'form_manual_update', to: 'menus#form_manual_update'
      end
    end
    
    resources :settings do
      collection do
        patch 'update', to: 'settings#update'
      end
    end
    
    resources :my_profile do
      collection do
        get 'edit', to: 'my_profile#edit'
        post 'update', to: 'my_profile#update'
      end
    end
    
  end
 
end

