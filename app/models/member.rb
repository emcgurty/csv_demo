class Member < ActiveRecord::Base

  set_table_name :memberrecords
  set_primary_key :member_id
  has_many :orders
  has_many :items, :through => :orders
  attr_accessible :member_id, :member_name, :member_address, :created_item
  after_create :sendmail
  
private

  def sendmail
	
    recipient = self.member_email
    subject = 'Welcome...'
    message = 
    body = {:member_name => self.member_name, 
				  :member_id => self.member_id,
                          :rand_password => self.rand_password,
                          :site_url => SITE_URL } 
    @alert = Notifier.member_alert(recipient, subject, message, body)
    @alert.deliver
  end
end

