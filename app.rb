require "sinatra"
require "sinatra/reloader"

get '/' do
  'hello world by sinatra'
  slim :index
end

get '/create_article' do
  @categories = Category.all
   slim :create_article
end

post '/article_post' do

  file = params[:file]
  thumbnail_name = file ? file[:filename] : params[:thumbnail]

  @post = Post.new(
    category_id: params[:category_id],
    title:       params[:title],
    body:        params[:body],
    thumbnail:   thumbnail_name
  )


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

end

get '/articles/:id' do
  # DBから:idの記事番号の記事を探して@postに入れる
  @post = Post.find_by(id: params[:id])
  # 投稿された記事のカテゴリーidと同じカテゴリーを探し、カテゴリー名を取得
  @category_name = Category.find(@post.category_id).name

  slim :articles
end
