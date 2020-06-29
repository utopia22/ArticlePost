require "sinatra"
require "sinatra/reloader"

get '/' do
  'hello world by sinatra'
  erb :index
end

get '/create_article' do
  @categories = Category.all
   erb :create_article
end

post '/article_post' do
  @post = Post.new(
    category_id: params[:category_id],
    title:       params[:title],
    body:        params[:body],
    thumbnail:   params[:file][:filename]
  )
  # DBに保存
  @post.save

  # 画像をpublic/imgに保存
  File.open("public/img/#{@post.thumbnail}", 'wb') do |f|
    f.write(params[:file][:tempfile].read)
  end
  redirect "/articles/#{@post.id}"
end

get '/articles/:id' do
  # DBから:idの記事番号の記事を探して@postに入れる
  @post = Post.find_by(id: params[:id])
  # 投稿された記事のカテゴリーidと同じカテゴリーを探し、カテゴリー名を取得
  @category_name = Category.find(@post.category_id).name

  erb :articles
end
