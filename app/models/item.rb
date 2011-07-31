class Item < ActiveRecord::Base

  set_table_name :shirtitems
  set_primary_key :item_id
  has_many :orders
  has_many :members, :through => :orders
 

end
