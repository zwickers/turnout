class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.integer :classroom_id
      t.string :university_id
      t.boolean :did_upload_photo
    end
  end
end
