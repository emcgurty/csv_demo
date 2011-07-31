class Size < ActiveRecord::Base

  set_table_name :itemsizes
  set_primary_key :size_id
  has_many :orders
 
end

