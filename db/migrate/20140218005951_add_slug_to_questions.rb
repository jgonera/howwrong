class AddSlugs < ActiveRecord::Migration
  def change
    change_table :questions do |t|
      t.string :slug
    end

    add_index :questions, :slug, unique: true
  end
end
