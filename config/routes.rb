ActionController::Routing::Routes.draw do |map|
  map.devise_for :users

  map.resources :sessions  
  map.resources :weights
  map.resources :steps
  map.resources :withings_log

  map.import_weight_csv '/importWeight', :controller => 'weights', :action => 'csv_import'
  map.import_steps_csv  '/importStep', :controller => 'steps', :action => 'csv_import'
  map.withings '/withings', :controller => 'withings', :action => 'log'
  map.withings_import '/withings/import', :controller => 'withings', :action => 'import'


  map.with_options :controller => 'static' do |static|
    static.home  '', :action => 'home'
    static.about '', :action => 'about'
  end

  map.root :controller => "static", :action => "home"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
