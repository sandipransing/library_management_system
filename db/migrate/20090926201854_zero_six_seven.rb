class ZeroSixSeven < ActiveRecord::Migration
  def self.up
    Setting.create!(:name => "site_title", :title => "Site Title",  :value => CONFIG['site_title'] || "File Management System", :setting_type => "Public", :description => "The Title of your Site. You would see this at the very top of your browser window.", :item_type => "string")
    Setting.create!(:name => "site_keywords", :title => "Site Keywords",  :value => "#{CONFIG['site_title'] }, ruby on rails", :setting_type => "Public", :description => "The Keywords Metatag for your site. Used for search engine submission. Seperated by commas.", :item_type => "string")
    Setting.create!(:name => "site_description", :title => "Site Description",  :value => "#{CONFIG['site_title']}, File Management System", :setting_type => "Public", :description => "The description for your site. Used in the title of your page(at the top of your browswer) and for search engine submission.", :item_type => "string")
    Setting.create!(:name => "let_users_change_default_folder", :title => "Let Users Change Default Folder",  :value => "0", :setting_type => "System", :description => "If enabled, this lets users change their default folder(the folder they go to when they log in).", :item_type => "bool") 
    Setting.create!(:name => "use_ferret", :title => "Use Ferret Search Indexing",  :value => "0", :setting_type => "System", :description => "If enabled, Ferret search indexing will be used. Ferret searching allows you to search inside certain text files. The <b>acts_as_ferret</b> gem must be installed for this to work.", :item_type => "bool")     
  end

  def self.down
  end
end
