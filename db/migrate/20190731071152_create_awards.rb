class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.string :title
      t.references :question, foreign_key: true
      t.references :user

      t.timestamps
    end
  end
end
