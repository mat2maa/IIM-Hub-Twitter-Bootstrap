# Remember to delete first row if it contains column headers
require 'csv'
require 'logger'

namespace :db do
  task :update_movies_by_title => :environment do
    logger = Logger.new STDOUT 
    
    @distributor_category = SupplierCategory.find_by_name("Movie Distributors")
    @laboratory_category = SupplierCategory.find_by_name('Laboratories')
    
    CSV.foreach("import/update_movies_by_title.csv") do |row|
      
      if !row[0].nil?

        puts row[0]
        
        distributor = Supplier.find_by_company_name(row[1]) #Movie Studio
        if distributor.nil? #Movie Studio
          distributor = Supplier.create(:company_name => row[1])
          distributor.supplier_categories << @distributor_category
          distributor.save
        elsif !distributor.supplier_categories.exists?(:name=> "Movie Distributors")
          distributor.supplier_categories << @distributor_category
          distributor.save
        end
        
        laboratory = Supplier.find_by_company_name(row[2]) #Lab        
        if laboratory.nil?
          laboratory = Supplier.create(:company_name => row[2])
          laboratory.supplier_categories << @laboratory_category
          laboratory.save
        elsif !laboratory.supplier_categories.exists?(:name=> "Laboratories")
          laboratory.supplier_categories << @laboratory_category
          laboratory.save
        end
          
        movie = Movie.find_by_movie_title(row[4]) # id
        
        if !movie.nil?
          movie.movie_distributor = distributor 
      		movie.laboratory = laboratory #Lab
          movie.movie_type = row[3]
      		movie.save(validate: false)
    		end
      end
    end 
  end  
	
end