CsvDemo::Application.routes.draw do


ActionController::Routing::Routes.draw do |map|   
      
	map.update    '/update', :controller => 'memberrecords', :action => 'update'
      map.create    '/create', :controller => 'memberrecords', :action => 'create'
      map.activate  '/activate/:rand_password', :controller => 'memberrecords', :action => 'activate'
      map.connect   ':controller/:action/:id.:format'
      map.root      :controller => 'memberrecords', :action => 'new'
   end
 match ':controller(/:action(/:id(.:format)))'
end
