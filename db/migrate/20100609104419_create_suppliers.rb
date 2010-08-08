class CreateSuppliers < ActiveRecord::Migration
  def self.up
    
    create_table :suppliers do |t|
      t.string :company_name
      t.string :contact_name_1
      t.string :position_1
      t.string :tel_1
      t.string :fax_1
      t.string :hp_1
      t.string :email_1    
      t.string :contact_name_2
      t.string :position_2
      t.string :tel_2
      t.string :fax_2
      t.string :hp_2
      t.string :email_2   
      t.text :address
      t.string :website
      t.text :remarks
      t.string :bank
      t.string :bank_branch
      t.string :bank_account
      t.text :aba_routing
      
      t.timestamps
    end

    create_table :supplier_categories_suppliers, :id => false do |t|
      t.integer :supplier_id
      t.integer :supplier_category_id
      
      t.timestamps
    end
    
  end

  def self.down  
    drop_table :suppliers
    drop_table :supplier_categories_suppliers
  end
end