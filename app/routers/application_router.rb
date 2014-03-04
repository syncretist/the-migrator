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
  @test_results  = TestResult.all
  @test_sessions = TestSession.all
  @test_statuses = TestStatus.all
  erb :'views/utility/test_results', :layout => utility_layout
end

post '/utilities/test_results' do
  TestResult.create(params)
  logger.info "POST RECEIVED VIA /utilities/test_results: #{params}"
  redirect to('..')
end

post '/utilities/test_status' do

  if params.has_key? "Fail"
    test_status = 'fail';
  elsif params.has_key? "Pass"
    test_status = 'pass'
  end

  TestStatus.create({"organization_id" => params[:organization_id],
                     "test_name" => params[:test_name],
                     "outcome_reason" => { :outcome_reason => params[:outcome_reason] }.to_json,
                     "test_status" => { :test_status => test_status }.to_json })
  logger.info "POST RECEIVED VIA /utilities/test_results: #{params}"
  redirect to('..')
end