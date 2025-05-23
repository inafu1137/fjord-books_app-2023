class CreateMentions < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :mentioner, null: false, foreign_key: { to_table: :reports }
      t.references :mentionee, null: false, foreign_key: { to_table: :reports }
      t.timestamps
    end

    add_index :mentions, [:mentioner_id, :mentionee_id], unique: true
  end
end
