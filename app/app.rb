require 'sinatra/base'
# require 'data_mapper'
# require 'data_mapper_setup'

class BookmarkManager < Sinatra::Base

  enable :sessions
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

    @message = "Sorry, your passwords do not match"

    if @user.save #save returns true/false depending on whether the model is successfully saved to the database. (NB The model doesn't save if the password validation fails.)
      session[:user_id] = @user.id
      redirect to('/')
    else
      # If it's not valid, we'll show the same form again
      erb :'users/new'
    end
  end

  helpers do
    def current_user
      @user||=User.get session[:user_id]
    end
  end
end
