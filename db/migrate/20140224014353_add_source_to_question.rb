class AddSourceToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :source, :string
    add_column :questions, :source_url, :string
  end
end
