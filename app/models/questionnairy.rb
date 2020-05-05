class Questionnairy < ApplicationRecord
  has_one_attached :yaml_file

  # validates_attachment_content_type :yaml_file, :content_type => ["text/yaml", "application/x-yaml", "application/octet-stream"]
  def yaml_path
    ActiveStorage::Blob.service.path_for(yaml_file.key)
  end
end
