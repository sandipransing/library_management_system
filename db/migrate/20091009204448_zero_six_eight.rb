class ZeroSixEight < ActiveRecord::Migration
  def self.up
    Setting.create(:name => "overwrite_existing_files", :title => "Overwrite Existing Files",  :value => "0", :setting_type => "System", :description => "If enabled, #{CONFIG[:app_name]} will overwrite identical files in a particular folder. If disabled, the new file will have a timestamp attached to its filename.", :item_type => "bool")         
  end

  def self.down
  end
end
