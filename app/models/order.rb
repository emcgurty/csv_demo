class Order < ActiveRecord::Base

   ## Insert validation code
   set_table_name :memberrecords_shirtitems
   set_primary_key :memberrecords_id
   belongs_to  :member
   belongs_to  :item
   belongs_to  :size
   attr_accessible :memberrecords_id, :member_id, :item_id, :size_id
   
end
