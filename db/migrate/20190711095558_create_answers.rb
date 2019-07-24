class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.text :body
      #t.references :question, foreign_key: true
      t.belongs_to :question, foreign_key: true

      t.timestamps null: false
    end
  end
end
