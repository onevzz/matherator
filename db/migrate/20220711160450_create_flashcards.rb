class CreateFlashcards < ActiveRecord::Migration[7.0]
  def change
    create_table :flashcards do |t|
      t.string :code
      t.string :question
      t.string :answer
      t.string :unit

      t.timestamps
    end
  end
end
