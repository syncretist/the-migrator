##
## error_pages_router.rb
##
## "the main router for all error page requests"
##
## sinatra processes the route handlers from top to bottom;
## as soon as it finds a match to the URL entered, it will process that handler.
##
## if an instance variable is set in the handler, it can be referred to in the associated view

#############
## Layouts ##
#############

error_layout = :'views/error-pages/error_layout'

############
## Assets ##
############

############
## Routes ##
############

not_found do
  erb :'views/error-pages/404', :layout => error_layout
end