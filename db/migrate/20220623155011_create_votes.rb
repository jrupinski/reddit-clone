class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :value, null: false

      t.index [:user_id, :votable_id, :votable_type], unique: true
      t.timestamps
    end
  end
end
