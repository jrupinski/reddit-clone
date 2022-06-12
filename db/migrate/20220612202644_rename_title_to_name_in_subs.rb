class RenameTitleToNameInSubs < ActiveRecord::Migration[7.0]
  def change
    rename_column :subs, :title, :name
  end
end
