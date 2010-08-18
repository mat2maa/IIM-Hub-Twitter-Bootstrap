class AddBeneficiaryName < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :beneficiary_name, :string
  end

  def self.down
    remove_column :suppliers, :beneficiary_name
  end
end
