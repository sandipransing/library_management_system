# Application-wide functionality used by controllers.
class ApplicationController < ActionController::Base
  before_filter :authorize # user should be logged in
  before_filter :load_settings # load global settings
  
  # Returns the id of the current folder, which is used by the
  # CRUD authorize methods to check the logged in user's permissions.
  def folder_id
    case params[:controller] + '/' + params[:action]
    when 'folder/index', 'folder/list', 'folder/new', 'folder/create', 'folder/update_permissions', 'folder/feed', 'file/upload', 'file/validate_filename'
      current_folder_id = 1 unless current_folder_id = params[:id]
    when 'file/do_the_upload'
      # This prevents a URL like 0.0.0.0/file/do_the_upload/12,
      # which breaks the upload progress. The URL now looks like this:
      # 0.0.0.0/file/do_the_upload/?folder_id=12
      current_folder_id = 1 unless current_folder_id = params[:folder_id]
    when 'folder/rename', 'folder/update', 'folder/destroy'
      current_folder_id = @folder.parent_id if @folder
    when 'file/download', 'file/rename', 'file/update', 'file/destroy', 'file/preview'
      current_folder_id = @myfile.folder.id
    end
    return current_folder_id
  end

  # Check if a folder exists before executing an action.
  # If it doesn't exist: redirect to 'list' and show an error message
  def does_folder_exist
    @folder = Folder.find(params[:id]) if params[:id]
  rescue
    flash[:notice] = "<div class=\"flash_failure\">Someone else deleted the folder you are using. Your action was cancelled and you have been taken back to the root folder.</div>"
    redirect_to :controller => 'folder', :action => 'list' and return false
  end

  # The #authorize method is used as a <tt>before_hook</tt> in most controllers.
  # If the session does not contain a valid user, the method redirects to either
  # AuthenticationController.login or AuthenticationController.create_admin (if no users exist yet).
  def authorize
    @logged_in_user = User.find(session[:user_id])
    log_request(@logged_in_user) # Log Request(Who did What)
  rescue
    reset_session
    @logged_in_user = nil
    if User.find(:all).length > 0
      session[:jumpto] = request.parameters
      redirect_to :controller => 'authentication', :action => 'login' and return false
    else
      redirect_to :controller => 'authentication', :action => 'create_admin' and return false
    end
  end

  # set user by a user_id arg passed through request instead of from session. 
  # This is a workaround for methods that crash when session data is present(ajax/flash).
  # The user_id passed in must be identical to session[:user_id], otherwise the methods that use this will think @logged_in_user is a different user! 
  def sessionless_authorize
    @logged_in_user = User.find(params[:user_id]) # find user by id passed in
    log_request(@logged_in_user) # Log Request(Who did What)
  rescue
    reset_session
    @logged_in_user = nil
    if User.find(:all).length > 0
      session[:jumpto] = request.parameters
      redirect_to :controller => 'authentication', :action => 'login' and return false
    else
      redirect_to :controller => 'authentication', :action => 'create_admin' and return false
    end    
  end

  # If the session does not contain a user with admin privilages (is in the admins
  # group), the method redirects to /folder/list
  def authorize_admin
    redirect_to(:controller => 'folder', :action => 'list') and return false unless @logged_in_user.is_admin?
  end

  # Redirect to the Root folder and show an error message
  # if current user cannot create in current folder
  def authorize_creating
    unless @logged_in_user.can_create(folder_id)
      flash[:notice] = "<div class=\"flash_failure\">You don't have create permissions for this folder.</div>"
      redirect_to :controller => 'folder', :action => 'list', :id => folder_id and return false
    end
  end

  # Redirect to the Root folder and show an error message
  # if current user cannot read in current folder
  def authorize_reading
    unless @logged_in_user.can_read(folder_id)
      flash[:notice] = "<div class=\"flash_failure\">You don't have read permissions for this folder.</div>"
      redirect_to :controller => 'folder', :action => 'list', :id => nil and return false
    end
  end

  # Redirect to the Root folder and show an error message
  # if current user cannot update in current folder
  def authorize_updating
    unless @logged_in_user.can_update(folder_id)
      flash[:notice] = "<div class=\"flash_failure\">You don't have update permissions for this folder.</div>"
      redirect_to :controller => 'folder', :action => 'list', :id => folder_id and return false
    end
  end

  # Check if the logged in user has permission to delete the file
  def authorize_deleting
    unless @logged_in_user.can_delete(folder_id)
      flash[:notice] = "<div class=\"flash_failure\">You don't have delete permissions for this folder.</div>"
      redirect_to :controller => 'folder', :action => 'list', :id => folder_id and return false
    end
  end

  def log_request(user) # Log the request of a logged in user.
    logger.info("User: #{user.name} - #{Time.now} - params: #{params.inspect}")
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

  def load_settings
   @setting = Hash.new
   @setting[:title] = Setting.get_setting("site_title")
   @setting[:meta_keywords] = Setting.get_setting("site_keywords")
   @setting[:meta_description] = Setting.get_setting("site_description")
   @setting[:meta_title] = @setting[:title] + " - " + @setting[:meta_description]
   end

end
