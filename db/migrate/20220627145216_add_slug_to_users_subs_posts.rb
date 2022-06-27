class AddSlugToUsersSubsPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true
    add_column :subs, :slug, :string
    add_index :subs, :slug, unique: true
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true
  end
end
