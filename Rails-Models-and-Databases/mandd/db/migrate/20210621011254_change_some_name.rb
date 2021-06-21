class ChangeSomeName < ActiveRecord::Migration[6.1]
  def change
    rename_column :jokes, :type, :jktype
  end
end
