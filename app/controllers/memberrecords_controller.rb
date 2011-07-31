require 'csv'

class MemberrecordsController < ApplicationController

  def create
       
       if request.post?
       	
       flash[:notice] = ""
       allreadyexists = params[:memberorders][:created_item].to_i 
       myID = params[:id]
       @mr = Member.find(:first, :conditions => ['member_id = ?', params[:id]]) 
       
              
	     #  In order to have multiple select boxes includes in params, each must have a uniq name, which is not 
	     #  consistent with later need in update_atrubutes
	     @mySizes =  params[:size].values
	     #  Remove all the "" the remaining value will be parallel with item_ids
	     @mySizes.keep_if  {|v| !(v=="")}
	
         size_ids = Hash.new 
         size_ids = @mySizes

	      if !(@mySizes.size == params[:memberrecords][:item_id].size)
	         flash[:notice] = "For each shirt, choose a size. If you choose a size, please choose the corresponding shirt."
	         return
	      end  

               j = 0
       
               for i in params[:memberrecords][:item_id]
	      	   if allreadyexists == 1 
                    
                        @order = @mr.orders.find(:first, :conditions => ['memberrecords_shirtitems.item_id = ?', i.to_i  ])
                          
                          if @order && (@order.size_id.to_i != @mySizes[j].to_i)
               
                         	begin
                     		  if @order.update_attribute("size_id", size_ids[j].to_i)
                                  puts "SUCCESS in UPDATE"
                              end
                            rescue Exception =>ex
                                 puts "ERROR IN UPDATE" + ex.message
                            end
                          else
                             @order = @mr.orders.new(:item_id => i.to_i, :size_id => @mySizes[j].to_i)
                             @order.save(:validate => false)
                         end    
			   else
			   	        @order = @mr.orders.new(:item_id => i.to_i, :size_id => @mySizes[j].to_i)
                        @order.save(:validate => false)

	      	   end
                j = j +1
           end
	      		
           begin
           	if @mr.update_attributes(
           	          :member_name => params[:memberorders][:member_name],
           	          :member_address => params[:memberorders][:member_address],
           	          :created_item => 1)
	          flash[:notice] = "Member record successfully updated"
      	   else
 	   	    flash[:notice] = "Member record not successfully updated"
           end
       rescue Exception => ex
       	 puts "ERROR in Memer update" + ex.message
   	 end
           
       end
      
	  end   ## closes def create


 def new 
  	 if request.post? 
         if session[:member_id]
           render :action => :newitems
         else
          myFileName =   params[:csv_rec][:csv_field].original_filename
          ##  Error trap with rescue here
          @parsed_file=CSV.open(myFileName)
          n=0
          @c=Member.new
               @parsed_file.each  do |row|
                   @c.member_name=row[0]
                   @c.member_address=row[1]
                   @c.member_email=row[2]
			       @c.memberrecords_id=row[3]
                   @c.rand_password = SecureRandom.hex(16)
                   @c.csv_field = myFileName
                   
                        ##  Error trap with rescue here
                        if @c.save(:validate=>false)   ## Triggers memberrecords Observer in generating email.... very slow
                           n +=1
                           GC.start if n%50==0
                           @c=Member.new   ## create a new instance otherwise records will be updated and not created as new in insert
                        end
                 end # end do
              flash[:notice] = "CSV Import Successful,  #{n} new records added to data base"
       end  
   end
  end

  def list
     
  end

   def newitems
      @mr = Member.find(:first, :conditions => ['member_id = ?', params[:id]])
      @memberorders = @mr.orders.new 
   end

   def edit
      @mr = Member.find(:first, :conditions => ['member_id = ?', params[:id]])
      @memberorders = @mr.orders.find(:all) 
      
   end

   def activate
     ##   See callingCard_ for activation process
     ##   For the moment
     @mr = Member.find(:first, :conditions => ['rand_password = ?', params[:rand_password]])
     session[:member_id] = @mr.member_id
     redirect_to :action => :list
   end



end