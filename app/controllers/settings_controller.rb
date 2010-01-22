class SettingsController < ApplicationController
 before_filter :authorize_admin
  
 def index
    @setting[:meta_title] = "Settings - " + @setting[:meta_title]
 end

 def update_settings
   flash[:notice] = "<div class=\"flash_success\">" 
   params[:setting].each do |name, value| 
    # Dave: here were are querying the db once for EVERY setting in the table, just to get the setting name.
    # This is a little costly, the alternative being a find(:all) that is indexed with a integer-style counter
    # ie: @settings[counter], but the problem is that if the settings in the html form are listed in any 
    # different order, updating will do nothing, since the form setting and the indexed find(:all) won't match.
    # In the long run, this won't be too bad, since the size of the settings table shouldn't be very large(< 100)
    @setting = Setting.find(:first, :conditions => ["name = ?", name]) 
    if @setting.value != value # the value of the setting has changed
     if @setting.update_attribute("value", value) # update the setting
      flash[:notice] << "The setting(#{name}) was updated!<br>"
     else # the setting failed saving 
      flash[:notice] << "<font color=red>The setting(#{name}) failed updating!</font><br>"
     end
    else # show that the setting hasn't changed
     #flash[:notice] << "<font color=grey>The Setting(#{name}) has not changed.<br></font>"
    end
   end
   flash[:notice] << "</div>"
   redirect_to :action => "index"
  end

end
