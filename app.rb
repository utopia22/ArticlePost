enable :sessions
enable :method_override

require "sinatra"
require "sinatra/reloader"

get '/' do
  @posts = Post.all

  slim :index
end

get '/create_article' do

  @categories = Category.all
   slim :create_article
end

post '/article_post' do
  login_required
  redirect '/create_article' unless params[:csrf_token] == session[:csrf_token]

  file = params[:file]
  thumbnail_name = file ? file[:filename] : params[:thumbnail]

  @post = Post.new(
    category_id: params[:category_id],
    title:       params[:title],
    body:        params[:body],
    thumbnail:   thumbnail_name
  )

if @post.valid?

  if file
    File.open("public/img/#{@post.thumbnail}", 'wb') do |f|
      f.write(params[:file][:tempfile].read)
    end
  end

  if params[:prev]

    @category_name = Category.find(@post.category_id).name

    slim :preview
  elsif params[:back]
     File.delete("public/img/#{params[:thumbnail]}")
     @categories = Category.all
     slim :create_article

  else

    @post.save
      redirect "/articles/#{@post.id}"
    end
  else

     @categories = Category.all
     slim :create_article
   end
end

get '/articles/:id' do

  @post = Post.find_by(id: params[:id])

  @category_name = Category.find(@post.category_id).name

  slim :articles
end

post '/articles/delete/:id' do
    @post = Post.find(params[:id])
    @post.destroy
    redirect '/'
end

get '/login' do
  slim :login
end

post '/login' do
  user = User.find_by(name: params[:name])

  if user&.authenticate(params[:password])
    session[:user_id] = user.id

    redirect '/'
  else

    slim :login
  end
end

delete '/logout' do
  session.clear

  redirect '/login'
end
