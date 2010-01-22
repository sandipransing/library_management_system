class ZeroSixSix < ActiveRecord::Migration
  def self.up
    add_column :users, :default_folder_id, :integer, :default => 1 # create a default folder attribute for users.
  end

  def self.down
  end
end
