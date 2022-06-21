class AddParentCommentForeignKeyToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :parent_comment, null: true
  end
end
