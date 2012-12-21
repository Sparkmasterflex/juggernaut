Juggernaut::Application.routes.draw do
  devise_for :users do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
  end
  
  resources :editors
  resources :pages
  resources :projects
  resources :images do
    member do
      put :reorder
    end
  end
  
  
  match "/validate/#{Image::TOKEN_URL}" => 'application#get_csrf_token', :as => :get_csrf_token, :via => :get

  root :to => "cms_editor#index"
end
