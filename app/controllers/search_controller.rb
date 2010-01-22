# The search controller contains the following actions:
# [#show_results] performs a full-text search using Ferret
class SearchController < ApplicationController
  # Performs a full-text search using Ferret.
  # Only the files that can be read are returned.
  def show_results
    if request.post?
      @search_query = params[:search][:query]
      @search_type = params[:search_type]
      @result = [] # array to hold the results
      if  @search_type == "content" # search file content, using ferret
        # Search with Ferret in both Folder (name)
        # and Myfile (filename and text)
        Folder.multi_search(@search_query, [Myfile]).each do |hit|
          if hit.class == Folder
            @result << hit if @logged_in_user.can_read(hit.id)
          elsif hit.class == Myfile
            @result << hit if @logged_in_user.can_read(hit.folder.id)
          end
        end
      elsif @search_type == "filename" # Added to BXR: search only filename, no ferret used
        @result = Myfile.find(:all, :conditions => ["filename like ?", "%#{@search_query}%"])
      end
    end
  end
  
  
  def tag # Added to BXR 
   if params[:tag]
      @tag = params[:tag]
      @result = [] # array to hold the results

      tag_matches = MyfileTag.find(:all, :conditions => ["name = ?", params[:tag]], :order => "created_at DESC")
      #@first_tag = @other_tags[0]
      @meta_title = "Files tagged #{params[:tag]}" + " - #{@meta_title}"

      for tag_match in tag_matches
          @result << tag_match.myfile if @logged_in_user.can_read(tag_match.myfile.folder.id)
      end
   end
  end
  
  
end