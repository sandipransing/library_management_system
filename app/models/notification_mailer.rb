# E-mails login data to newly created users
# and to users who have requested a new password
class NotificationMailer < ActionMailer::Base
  # E-mail file add notification
  def file_notification(file, user)
    @subject          = "New #{CONFIG['app_name']} file added"
    @body['name']     = user.name
    @body['title']     = file.filename
    @body['description'] = file.description
    @body['filetags'] = file.myfile_tags.collect{ |t| t.name }.join(',')
    @recipients       = user.email
    @from             = CONFIG['admin_email'] 
  end

end
