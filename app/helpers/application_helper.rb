# Global helper methods for views
module ApplicationHelper
  # Replace 'name' with 'username' in a message
  def name_to_username(msg)
    return msg.sub('Name', 'Username') if msg
  end

  # Returns the path to the given folder.
  # Link to self determines wether every part of the path links to itself.
  def path(folder, link_to_self)
    # the base url for a path is always the same:
    url = url_for(:controller => 'folder', :action => 'list', :id => nil)

    # start with the deepest folder and work your way up
    if link_to_self
      path = folder.name
      id = folder.id.to_s

      # get the folders until folder doesn't have a parent anymore
      # (you're working your way up now)
      until folder.parent == nil
        folder = folder.parent
        path = folder.name + "/" + path
      end

      # Finally, make it a link...
      path = '<a href="' + url + '/' + id + '">' + h(path) + '</a>'
    else
      path = h(folder.name)

      # get the folders until folder doesn't have a parent anymore
      # (you're working your way up now)
      until folder.parent == nil
        folder = folder.parent
        path = '<a href="' + url + '/' + folder.id.to_s + '">' + h(folder.name) + '</a> &#187; ' + path
      end
    end

    return path
  end

  def get_setting(name) # get a setting from the database
   setting = Setting.find(:first, :conditions => ["name = ?", name], :limit => 1 )
   return setting.value
  end
 
  def get_setting_bool(name) # get a setting from the database return true or false depending on "1" or "0"
   setting = Setting.find(:first, :conditions => ["name = ?", name], :limit => 1 )
   if setting.value == "1"
     return true
   else # not true
     return false
   end
  end  
end