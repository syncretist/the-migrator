#############
## Layouts ##
#############

test_session_layout  = :'views/test-sessions/test_session_layout'

############
## Assets ##
############


############
## Routes ##
############

get '/' do
  @test_sessions = TestSession.all

  if @test_sessions.empty?
    erb :'views/test-sessions/test_sessions', :layout => test_session_layout
  else
    redirect to TestSession.all(:fields => [:id]).last[:id]
  end
end

post '/' do
  test_session = TestSession.create(params[:test_session])
  # flash message TESTSESSION CREATED if successful save!
  redirect to("/#{test_session.id}")
end

get '/new' do
  @current_test_session = TestSession.new
  erb :'views/test-sessions/new_test_session', :layout => test_session_layout
end

get '/:id' do
  @current_test_session = TestSession.get(params[:id])
  @test_sessions = TestSession.all
  erb :'views/test-sessions/show_test_session', :layout => test_session_layout
end

put '/:id' do
  test_session = TestSession.get(params[:id])
  test_session.update(params[:test_session])
  redirect to("/#{test_session.id}")
end

delete '/:id' do
  # js or intersticial redirect popup ARE YOU SURE?
  # possible save to, 'deleted' versions which can be viewed seperately
  TestSession.get(params[:id]).destroy
  redirect to('/')
end

get '/:id/edit' do
  @current_test_session = TestSession.get(params[:id])
  erb :'/views/test-sessions/edit_test_session', :layout => test_session_layout
end