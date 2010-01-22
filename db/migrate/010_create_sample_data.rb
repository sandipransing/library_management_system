class CreateSampleData < ActiveRecord::Migration

  def self.up
    admin = User.new(:name => "admin", :password => "admin", :password_confirmation => "admin", :email => CONFIG['admin_email'] || "admin@test.com") 
    admin.is_the_administrator = true
    
    if admin.save # create base permissions & root folder
        Group.create_admins_group
        Folder.create_root_folder
        GroupPermission.create_initial_permissions
    end
    
    
  end 

  def self.down
  end
end
