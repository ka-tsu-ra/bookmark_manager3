require 'sinatra/base'
require 'sinatra/flash'
# require 'data_mapper'
# require './app/data_mapper_setup'

class BookmarkManager < Sinatra::Base
  use Rack::MethodOverride
  # this is for the DELETE/hidden _method field in sign out stuff. To overcome browsers' inability to send a DELETE request.

  enable :sessions
  register Sinatra::Flash

  set :session_secret, 'super secret'

  get '/' do
    redirect '/links'
  end

    get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title]) # 1. Create a link
    tags = params[:tag].split
    tags.each do |tag|
      link.tags << Tag.create(name: tag)
    end
    # 3. Adding the tag to the link's DataMapper collection.
    # p link.tags
    link.save # 4. Saving the link.
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end
# require 'bye_bug'
# bye_bug

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end
#
  # post '/users' do
  #   User.create(email: params[:email], password: params[:password])
  #   redirect to('/links')
  # end

  post '/users' do
    @user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])

    # @message = "Sorry, your passwords do not match"

    if @user.save #save returns true/false depending on whether the model is successfully saved to the database. (NB The model doesn't save if the password validation fails.)
      session[:user_id] = @user.id
      redirect to('/')
    else
      # If it's not valid, we'll show the same form again
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(email: params[:email], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    flash[:notice] = 'goodbye!'
    session[:user_id] = nil
    redirect '/'
  end

  get '/password_reset' do
    erb :'users/password_reset'
  end

  post '/password_reset' do
    user = User.first(email: params[:email])
    
    redirect to ('/password_token')
  end

  get '/password_token' do
    "Check your emails"
  end

  helpers do
    def current_user
      @current_user||=User.get session[:user_id]
    end
  end

end
