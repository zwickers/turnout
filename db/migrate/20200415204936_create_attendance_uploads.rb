class CreateAttendanceUploads < ActiveRecord::Migration
  def change
    create_table :attendance_uploads do |t|
      t.string :prof_email
      t.string :classroom_id
      t.string :date_of_picture
    end
  end
end
