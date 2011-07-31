class MemberObserver < ActiveRecord::Observer
  
 ##Sends welcome email to members with member id # and a pre-generated password and a link to the t-shirt ordering site

 observe :member


  def after_create(memberrecords)
	
    recipient = memberrecords.member_email
    subject = 'Welcome...'
    message = 
    body = {:member_name => memberrecords.member_name, 
				  :member_id => memberrecords.member_id,
                          :rand_password => memberrecords.rand_password,
                          :site_url => SITE_URL } 
    @alert = Notifier.member_alert(recipient, subject, message, body)
    @alert.deliver
  end




private

def getMemberPassword
 
  ## As a best practice passwords should not be stored on the database.  Rather the user would receive this 
  ## password that on return to the application would be forced to change it which would result in an encrpted 
  ## password, see CallingCard_ user registration process.  
  
end
 
end
