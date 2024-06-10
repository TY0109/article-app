class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title, limit:10, null:false
      t.text :content, null:false
      t.string :img
      
      t.references :user, foreign_key: true
      
      t.timestamps
    end
  end
end
