# A folder is a place where files can be stored.
# Folders can also have sub-folders.
# Via groups it is determined which actions the logged-in User can perform.
class Folder < ActiveRecord::Base
  include ActionView::Helpers::TextHelper # include text helper for truncate and other options  
  
  if ActiveRecord::Base.connection.tables.include?("settings") # if the settings table exists
    if Setting.get_setting_bool("use_ferret") # and the use_ferret setting is on
      acts_as_ferret :store_class_name => true, :fields => { :name => { :store => :no } } # enable ferret
    end 
  end 
  
  acts_as_tree :order => 'name'

  belongs_to :user
  has_many :myfiles, :dependent => :destroy
  has_many :group_permissions, :dependent => :destroy

  validates_uniqueness_of :name, :scope => 'parent_id'
  validates_presence_of :name

  attr_accessible :name

  # List subfolders
  # for the given user in the given order.
  def list_subfolders(logged_in_user, order)
    folders = []
    if logged_in_user.can_read(self.id)
      self.children.find(:all, :order => order).each do |sub_folder|
        folders << sub_folder if logged_in_user.can_read(sub_folder.id)
      end
    end

    # return the folders:
    return folders
  end

  # List subfolders
  # for the given user in the given order.
  def list_all_folders(logged_in_user, order)
    folders = []
    if logged_in_user.can_read(self.id)
      self.children.find(:all, :order => order).each do |sub_folder|
        folders << sub_folder if logged_in_user.can_read(sub_folder.id)
      end
    end

    # return the folders:
    return folders
  end

  def print(options = {})    # recursive print out of folder name and other information 
    # initialize default values for options
    options[:depth]            ||= 25      # how many levels to descend
    options[:make_link]        ||= true   # make the folder name a link to the folder page
    options[:make_radio_button]||= false  # add an <input type="radio"... button 
    options[:input_name]       ||= "folder_id" # name of the html input object 
    options[:id_to_check ]     ||= 0  # if the id to check matches the folder id, select the radio button
    options[:truncate_length]  ||= 30     # Truncate name after this amount of characters
    
    # Set up formatting 
    html = "<div class=\"folder_indent\">\n"  
      html += "<table cellpadding=0 cellspacing=0 style=\"width:100%\"><tr>" 
        html += "<td style=\"width:100%;\"><a href=\"/folder/list/#{self.id}\" title=\"#{self.name}\"><b>#{truncate(self.name, :length => options[:truncate_length])}</b></a></td>"
        if options[:id_to_check] == self.id && options[:make_radio_button] # this is the folder we're looking for
          html += "<td align=right><input type=\"radio\" name=\"#{options[:input_name]}\" value=\"#{self.id}\" CHECKED></td>"
        elsif options[:make_radio_button] # not the folder we're looking for
          html += "<td align=right><input type=\"radio\" name=\"#{options[:input_name]}\" value=\"#{self.id}\"></td>"
        end
      html += "</tr></table>\n" 
    if options[:depth] > 0 # if we can still descend
      sub_folders = Folder.find(:all, :conditions => ["parent_id = ?", self.id], :order => "name ASC")    
      for sub_folder in sub_folders # for each of the children...
         options[:depth] = options[:depth] - 1 # decrement depth counter
         options[:truncate_length] = options[:truncate_length] - 1 # decrement truncate length by x characters
         html += sub_folder.print options # call recursive print_folder for child.
      end
    end
    html += "</div>\n"
    return html
  end 



  # List the files
  # for the given user in the given order.
  def list_files(logged_in_user, order)
    files = []
    if logged_in_user.can_read(self.id)
      files = self.myfiles.find(:all, :order => order)
    end

    # return the files:
    return files
  end

  # Returns whether or not the root folder exists
  def self.root_folder_exists?
    folder = Folder.find_by_is_root(true)
    return (not folder.blank?)
  end

  # Create the Root folder
  def self.create_root_folder
    if User.admin_exists? #and  Folder.root_folder_exists?
      folder = self.new
      folder.name = 'Root folder'
      folder.date_modified = Time.now
      folder.is_root = true

      # This folder is created by the admin
      if user = User.find_by_is_the_administrator(true)
        folder.user = user
      end

      folder.save # this hopefully returns true
    end
  end

  
end
