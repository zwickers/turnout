class AddProfIdToAttendanceUploads < ActiveRecord::Migration
  def change
    add_column :attendance_uploads, :prof_id, :string
  end
end
