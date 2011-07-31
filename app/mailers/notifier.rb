class Notifier < ActionMailer::Base

  default :charset => "utf-8"
  default :content_type => "text/html"
  

def member_alert(recipient, subject, message, body, sent_at = Time.now)
     do_contact(recipient, subject, message, body, sent_at = Time.now)

   end


   private

   def do_contact(recipient, subject, message, body, sent_at = Time.now)

      @subject = subject
      @recipients = recipient
      @from = '@gmail.com'
      @message = message
      @sent_on = sent_at
      @body = body
      #@headers = {}

end

end
