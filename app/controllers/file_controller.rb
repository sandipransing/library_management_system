# The file controller contains the following actions:
# [#download]          downloads a file to the users system
# [#progress]          needed for upload progress
# [#upload]            shows the form for uploading files
# [#do_the_upload]     upload to and create a file in the database
# [#validate_filename] validates file to be uploaded
# [#rename]            show the form for adjusting the name of a file
# [#update]            updates the name of a file
# [#destroy]           delete files
# [#preview]           preview file; possibly with highlighted search words
class FileController < ApplicationController

  skip_before_filter :authorize, :only => [:do_the_upload_multi]
  before_filter :sessionless_authorize, :only => [:do_the_upload_multi]
  before_filter :does_folder_exist, :only => [:upload, :upload_multi, :do_the_upload, :do_the_upload_multi] # if the folder DOES exist, @folder is set to it
  before_filter :does_file_exist, :except => [:upload, :upload_multi, :progress, :do_the_upload, :validate_filename, :do_the_upload_multi] # if the file DOES exist, @myfile is set to it
  before_filter :authorize_creating, :only => [:upload]
  before_filter :authorize_reading, :only => [:download, :preview]
  before_filter :authorize_updating, :only => [:rename, :update]
  before_filter :authorize_deleting, :only => :destroy

  #session :off, :only => [:progress]




  # The requested file will be downloaded to the user's system.
  # Which user downloaded which file at what time will be logged.
  # (adapted from http://wiki.rubyonrails.com/rails/pages/HowtoUploadFiles)
  def download
    # Log the 'usage' and return the file.
    usage = Usage.new
    usage.download_date_time = Time.now
    usage.user = @logged_in_user
    usage.myfile = @myfile

    if usage.save
      send_file @myfile.path, :filename => @myfile.filename
    end
  end

  # Shows the form where a user can select a new file to upload.
  def upload
    @myfile = Myfile.new
  end

  # Upload Multiple Files.
  def upload_multi
    if @logged_in_user.can_create(@folder.id) # check creation permissions, before_filter: authorize_creating workaround.
     @myfile = Myfile.new
    else # they can't create in the folder
      flash[:notice] = "<div class=\"flash_failure\">You don't have create permissions for this folder.</div>"
      redirect_to :action => "list", :controller => "folder", :id => @folder.id
    end
  end





  def do_the_upload # now with multiple file upload 
    counter = 0
    while(params["file_#{counter}".to_s] != "") # the first file is params[:file_0]
	    @myfile = Myfile.new()
	    @myfile.myfile = params["file_#{counter}".to_s] # Myfile.myfile contains the actual data
	    @myfile.folder_id = folder_id
	    @myfile.date_modified = Time.now
	    @myfile.user = @logged_in_user
	    @myfile.description = params[:description]

	    # handle existing identical files
	    if not Myfile.find_by_filename_and_folder_id(@myfile.filename, folder_id).blank? # does file exist? 
       if get_setting_bool("overwrite_existing_files") # overwrite existing files? 
        Myfile.find_by_filename_and_folder_id(@myfile.filename, folder_id).destroy # delete existing file
       else # don't overwrite, add timestamp
        @myfile.filename = File::basename(@myfile.filename, File::extname(@myfile.filename)) + '_' + Time.now.strftime('%Y%m%d%H%M%S') +  File::extname(@myfile.filename)
       end
	    end

	    if @myfile.save
      		# Check if any tags were entered
          make_tag(params[:tag_1], @myfile) if params[:tag_1] != ""	       	
          make_tag(params[:tag_2], @myfile) if params[:tag_2] != ""      
          make_tag(params[:tag_3], @myfile) if params[:tag_3] != ""
      
	    else
	      #render :template =>'file/upload_without_progress' unless USE_UPLOAD_PROGRESS
	    end
      counter += 1 # move to next file	 
   end # end file loop

   redirect_to :controller => 'folder', :action => 'list', :id => folder_id

  end


  def do_the_upload_multi # now with multiple file upload 
    counter = 0
    if @logged_in_user.can_create(@folder.id) # make sure user is logged in, improv for authorize(application.rb) because it's causing a marshal_dump error
    #while(params["file_#{counter}".to_s] != "") # the first file is params[:file_0]
      @myfile = Myfile.new()
      @myfile.myfile = params["Filedata".to_s] # Myfile.myfile contains the actual data
      @myfile.folder_id = @folder.id
      @myfile.date_modified = Time.now
      @myfile.user = @logged_in_user

      # handle existing identical files
      if not Myfile.find_by_filename_and_folder_id(@myfile.filename, @folder.id).blank? # does file exist? 
        #logger.info "Identical File Found! #{@folder.inspect}"
       if get_setting_bool("overwrite_existing_files") # overwrite existing files? 
        overwritten_file = Myfile.find_by_filename_and_folder_id(@myfile.filename, @folder.id).destroy # delete existing file
        logger.info "Identical File Found and overwritten ! #{overwritten_file.inspect}"
       else # don't overwrite, add timestamp
        @myfile.filename = File::basename(@myfile.filename, File::extname(@myfile.filename)) + '_' + Time.now.strftime('%Y%m%d%H%M%S') +  File::extname(@myfile.filename)
       end
      end


      if @myfile.save

      else
       logger.info("File Failed to save! " + @myfile.inspect + "\n\n")
        #render :template =>'file/upload_without_progress' unless USE_UPLOAD_PROGRESS
      end
      counter += 1 # move to next file   

      #logger.info(@myfile.inspect)
      #logger.info("\n\n" + params[:id])
      #logger.info(@myfile.inspect.errors.inspect)      
      render :text => "1" # return for flash/ajax call 
   else
    flash[:notice] = "<div class=\"flash_failure\">You don't have create permissions for this folder.</div>"
    redirect_to :action => "list", :controller => "folder", :id => @folder.id
  
   end 
   



  end



  # Validates a selected file in a file field via an Ajax call
  def validate_filename
    filename = CGI::unescape(request.raw_post).chomp('=')
    filename = Myfile.base_part_of(filename)
    if Myfile.find_by_filename_and_folder_id(filename, folder_id).blank?
      render :text => %(<script type="text/javascript">document.getElementById('submit_upload').disabled=false;\nElement.hide('error');\nElement.hide('spinner');</script>)
    else
      render :text => %(<script type="text/javascript">document.getElementById('error').style.display='block';\nElement.hide('spinner');</script>\nThis file can not be uploaded, because it already exists in this folder.)
    end
  end

  # Show a form with the current name of the file in a text field.
  def edit
  end

  # Update the name of the file with the new data.
  def update
    if request.post?
      if @myfile.update_attributes(:filename => Myfile.base_part_of(params[:myfile][:filename]), :date_modified => Time.now, :description => params[:myfile][:description])
        redirect_to :controller => 'folder', :action => 'list', :id => folder_id
      else
        render_action 'edit'
      end
    end
  end

  # Preview file; possibly with highlighted search words.
  def preview
    if @myfile.indexed
      if params[:search].blank? # normal case
        @text = @myfile.text
      else # if we come from the search results page
        @text = @myfile.highlight(params[:search], { :field => :text, :excerpt_length => :all, :pre_tag => '[h]', :post_tag => '[/h]' })
      end
    end
  end

  # Delete a file.
  def destroy
    @myfile.destroy
    redirect_to :controller => 'folder', :action => 'list', :id => folder_id
  end

  def create_tag
   myfile = Myfile.find(params[:myfile_id])
   @tag = MyfileTag.new(:name => params[:tag], :myfile_id => params[:myfile_id])
   if @tag.save
     flash.now[:notice] = 'Tag was successfully added.'
     redirect_to :controller => 'folder', :action => 'list', :id => @tag.myfile.folder_id
   else
     flash.now[:notice] = 'Tag was not added. There was an error.'  # get any errors
     redirect_to :controller => 'folder', :action => 'list'
   end
  end
  
  def destroy_tag
   @tag = MyfileTag.find(params[:id], :limit => 1)
   @tag.destroy # delete the comment
   flash[:notice] = "Tag destroyed!"
   redirect_to :controller => 'folder', :action => 'list', :id => @tag.myfile.folder_id
  end


  # These methods are private:
  # [#does_file_exist] Check if a file exists before executing an action
  private
    # Check if a file exists before executing an action.
    # If it doesn't exist: redirect to 'list' and show an error message
    def does_file_exist
      @myfile = Myfile.find(params[:id])
    rescue
      flash.now[:folder_error] = 'Someone else deleted the file you are using. Your action was cancelled and you have been taken back to the root folder.'
      redirect_to :controller => 'folder', :action => 'list' and return false
    end
  
    def make_tag(tag_name, myfile)
      return MyfileTag.create(:name => tag_name, :myfile_id => myfile.id)
    end
    
end
