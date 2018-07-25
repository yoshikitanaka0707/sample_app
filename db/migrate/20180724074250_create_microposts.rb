class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :microposts, [:user_id, :created_at]
    #マイクロポストの文面、投稿者で検索したり、登り順、下り順ですぐさま並び替えれる。
  end
end
