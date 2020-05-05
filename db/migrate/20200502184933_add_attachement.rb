class AddAttachement < ActiveRecord::Migration[5.2]
  def up
    add_attachment :questionnairies, :yaml_file
  end

  def down
    remove_attachment :questionnairies, :yaml_file
  end
end
