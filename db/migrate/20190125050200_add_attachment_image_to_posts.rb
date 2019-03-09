class AddAttachmentImageToPosts < ActiveRecord::Migration[5.2]
  def self.up
    add_attachment :posts, :image
  end

  def self.down
    remove_attachment :posts, :image
  end
end
