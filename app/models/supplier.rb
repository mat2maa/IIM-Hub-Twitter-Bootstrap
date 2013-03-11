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
  
  attr_accessible :company_name, :supplier_category_ids, :contact_name_1, :position_1, :tel_1, :fax_1, :hp_1,
                  :email_1, :contact_name_2, :position_2, :tel_2, :fax_2, :hp_2, :email_2, :address, :website,
                  :remarks, :bank, :bank_branch, :beneficiary_name, :bank_account, :aba_routing

end
