# Helper methods for search views
module SearchHelper
    def link_order(name, order_by)
    if params[:order] == nil and params[:order_by] == order_by
      link_to(name, :action => 'list', :id => params[:id], :order_by => order_by, :order => 'DESC') + image_tag('asc.png')
    elsif params[:order] and params[:order_by] == order_by
      link_to(name, :action => 'list', :id => params[:id], :order_by => order_by) + image_tag('desc.png')
    else
      link_to name, :action => 'list', :id => params[:id], :order_by => order_by
    end
  end
end
