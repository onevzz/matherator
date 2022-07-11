class CreateDecks < ActiveRecord::Migration[7.0]
  def change
    create_table :decks do |t|
      t.string :code
      t.string :content

      t.timestamps
    end
  end
end
