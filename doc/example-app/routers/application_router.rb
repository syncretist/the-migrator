##
## application_router.rb
##
## "the main router for application requests
##
## sinatra processes the route handlers from top to bottom;
## as soon as it finds a match to the URL entered, it will process that handler.
##
## if an instance variable is set in the handler, it can be referred to in the associated view

#############
## Layouts ##
#############

main_layout  = :'views/main_layout'

############
## Assets ##
############

get('/styles.css'){ scss :'assets/sass/styles' }

############
## Routes ##
############

get '/' do
  erb :'views/home', :layout => main_layout
end

get '/about' do
  erb :'views/about', :layout => main_layout
end

get '/contact' do
  erb :'views/contact', :layout => main_layout
end

get '/what/time/is/it/in/:number/hours' do
  number = params[:number].to_i
  time = Time.now + number * 3600
  "The time in #{number} hours will be #{time.strftime('%I:%M %p')}"
end

post '/get-data' do
  @data = params
  logger.info "POST RECEIVED VIA /get-data: #{@data}"
  redirect to("/songs")
end