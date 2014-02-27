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
  @test_sessions = TestSession.all
  erb :'views/utility/test_results', :layout => utility_layout
end

post '/utilities/test_results' do
  TestResult.create(params)
  logger.info "POST RECEIVED VIA /utilities/test_results: #{params}"
  redirect to('..')
end

post '/utilities/test_results/pass' do
  test_results = {}
  test_results[:outcome_reason] = params[:outcome_reason]
  test_results[:outcome] = :pass
  TestResult.create({"organization_id" => params[:organization_id], "test_name" => params[:test_name], "test_results" => test_results.to_json })
  logger.info "POST RECEIVED VIA /utilities/test_results: #{params}"
  redirect to('..')
end

post '/utilities/test_results/fail' do
  test_results = {}
  test_results[:outcome_reason] = params[:outcome_reason]
  test_results[:outcome] = :fail
  TestResult.create({"organization_id" => params[:organization_id], "test_name" => params[:test_name], "test_results" => test_results.to_json })
  logger.info "POST RECEIVED VIA /utilities/test_results: #{params}"
  redirect to('..')
end