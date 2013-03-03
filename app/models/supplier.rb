class Supplier < ActiveRecord::Base
  has_many :movies
  has_many :videos
  
  has_and_belongs_to_many :supplier_categories

  validates_presence_of :company_name

  scope :video_distributors, :include => :supplier_categories,
      :conditions => { 'supplier_categories.name' => "Video Distributors" }, :order => 'company_name asc'
  scope :movie_distributors, :include => :supplier_categories,
      :conditions => { 'supplier_categories.name' => "Movie Distributors" }, :order => 'company_name asc'
  scope :laboratories, :include => :supplier_categories,
      :conditions => { 'supplier_categories.name' => "Laboratories" }, :order => 'company_name asc'
  scope :production_studios, :include => :supplier_categories,
      :conditions => { 'supplier_categories.name' => "Production Studios" }, :order => 'company_name asc'
  
  def categories_to_s
    supplier_categories.collect {|category| category.name}.join(', ')
  end

end
