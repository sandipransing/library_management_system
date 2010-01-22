class Setting < ActiveRecord::Base
 validates_uniqueness_of :name
 validates_presence_of :name, :value
  
 def validate
 end

 
  def self.get_setting(name) # get a setting from the database
   setting = Setting.find(:first, :conditions => ["name = ?", name], :limit => 1 )
     return setting.value
    end
   
    def self.get_setting_bool(name) # get a setting from the database return true or false depending on "1" or "0"
   setting = Setting.find(:first, :conditions => ["name = ?", name], :limit => 1 )
   if setting.value == "1"
     return true
   else # not true
     return false
   end
  end  
end
