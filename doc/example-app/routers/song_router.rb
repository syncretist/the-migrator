##
## song_router.rb
##
## "the main router for all song model related requests"
##
## sinatra processes the route handlers from top to bottom;
## as soon as it finds a match to the URL entered, it will process that handler.
##
## if an instance variable is set in the handler, it can be referred to in the associated view

#############
## Layouts ##
#############

song_layout = :'views/songs/song_layout'

############
## Assets ##
############

get('/song.css'){ scss :'assets/sass/songs/song' }

############
## Routes ##
############

get '/songs' do
  @songs = Song.all
  erb :'views/songs/song', :layout => song_layout
end

post '/songs' do
  song = Song.create(params[:song])
  # flash message SONG CREATED if successful save!
  redirect to("/songs/#{song.id}")
end

get '/songs/new' do
  @song = Song.new
  erb :'views/songs/new_song', :layout => song_layout
end

get '/songs/:id' do
  @song = Song.get(params[:id])
  erb :'views/songs/show_song', :layout => song_layout
end

put '/songs/:id' do
  song = Song.get(params[:id])
  song.update(params[:song])
  redirect to("/songs/#{song.id}")
end

delete '/songs/:id' do
  # js or intersticial redirect popup ARE YOU SURE?
  # possible save to, 'deleted' versions which can be viewed seperately
  Song.get(params[:id]).destroy
  redirect to('/songs')
end

get '/songs/:id/edit' do
  @song = Song.get(params[:id])
  erb :'/views/songs/edit_song', :layout => song_layout
end

