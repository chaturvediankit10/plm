Rails.application.routes.draw do


  scope :module => 'buttercms' do
    get '/research_categories/:slug' => 'categories#show', :as => :buttercms_category
    get '/author/:slug' => 'authors#show', :as => :buttercms_author

    get '/research/rss' => 'feeds#rss', :format => 'rss', :as => :buttercms_blog_rss
    get '/research/atom' => 'feeds#atom', :format => 'atom', :as => :buttercms_blog_atom
    get '/research/sitemap.xml' => 'feeds#sitemap', :format => 'xml', :as => :buttercms_blog_sitemap

    get '/research(/page/:page)' => 'posts#index', :defaults => {:page => 1}, :as => :buttercms_blog
    get '/research/:slug' => 'posts#show', :as => :buttercms_post
  end

  get '/calculation', to: 'pages#calculation', as: 'calculation'

  devise_for :admin_users, ActiveAdmin::Devise.config

  get "admin/fannie_mae", to: 'admin/fannie_maes#index', as: 'admin_fannie_maes'
  ActiveAdmin.routes(self)

  #devise_for :users
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  ActiveAdmin.register_page "UploadCsv"

 # authenticated :user do
   # root to: 'pages#index', as: :authenticated_root
  # end
  post 'pages/expert_user_registration', to: "pages#expert_user_registration", as: 'expert_user_registration'

  get 'pages/expert_state_and_city', to: 'pages#expert_state_and_city', as: 'expert_state_and_city'

  get 'pages/expert_city_and_zip', to: 'pages#expert_city_and_zip', as: 'expert_city_and_zip'

  # root 'search#index'
  # get 'search/index'
  root :to => "search#home", via: [ :post, :get]
  get '/fetch_programs', to: 'search#fetch_programs', as: :fetch_programs
  get 'pages/index'
  get '/set_state_by_zip_code', to: 'search#set_state_by_zip_code', as: :set_state_by_zip_code
  get '/favorite_program', to: 'pages#favorite_program', as: :favorite_program

  # get '/refinance+rates', to: 'pages#refinance', as: 'refinance'
  match '/refinance+rates' => 'pages#refinance', as: 'refinance', via: [ :post, :get]
  match '/mortgage+rates' => 'pages#mortgage', as: 'mortgage', via: [ :post, :get]
  post '/contact_us_email', to: 'pages#contact_us_email'
  get '/change_status', to: 'pages#change_status'
  get '/activate', to: 'pages#user_mass_activate'
  get '/deactivate', to: 'pages#user_mass_deactivate'
  get '/profile', to: 'pages#user_profile'
  put '/update_profile', to: 'pages#update_profile'
  get '/pages/:page_slug',to: 'pages#show', as: 'show_cms_pages'

  post '/research_contact_us_email', to: 'pages#research_contact_us_email', as: "research_contact_us_email"

  post '/research_post', to: 'pages#research_post', as: 'research_post'

  get '/city_freddie_cache_data', to: 'pages#city_freddie_cache_data', as: 'city_freddie_cache_data'

  # for dynamic cmspages
  #CmsPage.load                      if CmsPage.present?

  #--------------------------- routes for mortgage loan pages ---------------------------------
  get '/mortgage/lender/:alphabet', to: 'directories#mortgage_state_banks', as: 'mortgage_state_banks'

  get '/mortgage/lender/:alphabet-(:bank_from)-(:bank_to)/:bank_list', to: 'directories#mortgage_state_banks_list', as: 'mortgage_banks_list'

  # get 'mortgage/lender-(:cert)/(:bank_name+mortgage)', to: 'seo_pages#bank_mortgage_loans', as: 'bank_home_mortgage_loan'
  match '/mortgage/lender-(:cert)/(:bank_name+mortgage)' => 'seo_pages#bank_mortgage_loans', as: 'bank_home_mortgage_loan', via: [ :post, :get]


  #--------------------------- routes for personal loan pages ----------------------------------

  get '/personal+loan/lender/:alphabet', to: 'directories#personal_loan_state_banks', as: 'personal_loan_state_banks'

  get '/personal+loan/lender/:alphabet-(:bank_from)-(:bank_to)/:bank_list', to: 'directories#personal_loan_state_banks_list', as: 'personal_loan_state_banks_list'

  get 'personal+loan/lender-(:cert)/(:bank_name+personal+loans)', to: 'seo_pages#bank_personal_loans', as: 'bank_home_personal_loan'

  #--------------------------- routes for auto loan pages ----------------------------------

  get '/auto+loan/lender/:alphabet', to: 'directories#auto_loan_state_banks', as: 'auto_loan_state_banks'

  get '/auto+loan/lender/:alphabet-(:bank_from)-(:bank_to)/:bank_list', to: 'directories#auto_loan_state_banks_list', as: 'auto_loan_state_banks_list'

  get 'auto+loan/lender-(:cert)/(:bank_name+auto+loans)', to: 'seo_pages#bank_auto_loans', as: 'bank_home_auto_loan'


  #-------------------------- routes for directory pages------------------------------
  get '/directory', to: 'directories#directory_root', as: 'directory'

  #-------------------------- routes for city mortgage pages------------------------------
  # get '/mortgage/:state-(:city_id)(/:city+mortgage+rates)', to: 'seo_pages#city_home_mortgage_rates', as: 'city_home_mortgage_rates'

  match '/mortgage/:state-(:city_id)(/:city+mortgage+rates)' => 'seo_pages#city_home_mortgage_rates', as: 'city_home_mortgage_rates', via: [ :post, :get]

  get '/mortgage/:state', to: 'directories#mortgage_state_cities', as: 'mortgage_state_cities'

  get '/mortgage/:state-(:city_from)-(:city_to)/:city_list', to: 'directories#mortgage_state_cities_list', as: 'mortgage_state_cities_list'


  #--------------------------- routes for city refinance pages ----------------------------------

  # get '/refinance/:state-(:city_id)(/:city+refinance+rates)', to: 'seo_pages#city_home_refinance_rates', as: 'city_home_refinance_rates'

  match '/refinance/:state-(:city_id)(/:city+refinance+rates)' => 'seo_pages#city_home_refinance_rates', as: 'city_home_refinance_rates', via: [ :post, :get]


  get '/refinance/:state', to: 'directories#refinance_state_cities', as: 'refinance_state_cities'

  get '/refinance/:state-(:city_from)-(:city_to)/:city_list', to: 'directories#refinance_state_cities_list', as: 'refinance_state_cities_list'


  #--------------------------- routes for calculator controller ----------------------------------

  get '/mortgage+calculator', to: 'calculator#index', as: 'calculator'
  get 'get_todays_rate', to: 'calculator#get_todays_rate'

  #--------------------------- route for wrong requested pages ----------------------------------

  # match '*path', to: redirect('/'), via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
