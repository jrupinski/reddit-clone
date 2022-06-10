class RemovePostIndexOnSubId < ActiveRecord::Migration[7.0]
  def change
    remove_reference :posts, :sub, null: false, foreign_key: true
  end
end
