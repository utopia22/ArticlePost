class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t| # postsがテーブル名
      t.integer :category_id
      t.string  :title, null: false
      t.text    :body,  null: false
      t.string  :thumbnail, null: false

      t.timestamps # これを書くとcreated_atとupdated_atカラムが自動定義される
  end
end
end
