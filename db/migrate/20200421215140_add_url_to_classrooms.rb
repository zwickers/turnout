class AddUrlToClassrooms < ActiveRecord::Migration
  def change
    add_column :classrooms, :url, :string
  end
end
