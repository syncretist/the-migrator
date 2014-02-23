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

utility_layout  = :'views/utility/utility_layout'

############
## Assets ##
############


############
## Routes ##
############

get '/utilities/test_results' do
  @test_results = TestResult.all
  erb :'views/utility/test_results', :layout => utility_layout
end

post '/utilities/test_results' do
  #@test_result = TestResult.new
  TestResult.create(params)
  logger.info "POST RECEIVED VIA /utilities/test_results: #{params}"
end