require 'fastercsv'

namespace :db do
  task :import_labs => :environment do

    FasterCSV.foreach("import/labs.csv") do |row|    
      if !row[0].nil?
        
        categories = SupplierCategory.find(:all, :conditions => "name like '%Labor%'")
    		puts row[0]
    
        supplier = Supplier.new
    		supplier.company_name = row[0]
    		supplier.contact_name_1 = row[1]
    		supplier.position_1 = row[2]
    		supplier.tel_1 = row[3]
    		supplier.fax_1 = row[4]
    		supplier.hp_1 = row[5]
    		supplier.email_1 = row[6]
    		supplier.contact_name_2 = row[7]
    		supplier.position_2 = row[8]
    		supplier.tel_2 = row[9]
    		supplier.fax_2 = row[10]
    		supplier.hp_2 = row[11]
    		supplier.email_2 = row[12]
    		supplier.address = row[13]
    		supplier.website = row[14]
    		supplier.remarks = row[15]
    		supplier.bank = row[16]
    		supplier.bank_branch = row[17]
    		supplier.bank_account = row[18]
    		supplier.aba_routing = row[19]
    		supplier.supplier_categories << categories
    		supplier.save
    		
  		end
    end 
  end  
end