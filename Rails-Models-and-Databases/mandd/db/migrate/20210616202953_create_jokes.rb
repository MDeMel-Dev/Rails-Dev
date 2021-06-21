class CreateJokes < ActiveRecord::Migration[6.1]
  def change
    create_table :jokes do |t|
      t.string :desc
      t.string :type

      t.timestamps
    end
  end
end
