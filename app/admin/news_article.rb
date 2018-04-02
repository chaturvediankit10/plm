ActiveAdmin.register NewsArticle ,as: "NewsArticle" do
  menu false
  # Permitting View and index actions only
  actions :all, except: [:new, :edit]
  # Permitting Strong parameters
  permit_params :search_term,:date_article, :datetime, :url, :author, :headline, :text, :api_type

  #enum api_type_enum: {'New York Times'=>0,'Microsoft Bing'=>1}

  action_item 'Back', only: :show do
    link_to('Back', :back)
  end
  
  index do
    selectable_column
    column :date_article
    column :headline
    column :author
    column :search_term
    column :api_type
    column :text
    column :created_at
    actions name: "Actions"
  end

  filter :search_term
  filter :date_article
  filter :api_type, as: :select,include_blank: false, collection: {'New York Times'=>0,'Microsoft Bing'=>1}

  show title: "NewsArticle" do
    panel "NewsArticle Details" do
      attributes_table_for news_article, :search_term,:date_article, :url, :author, :headline, :text, :api_type, :article_id
    end
  end
end
