class AddCompanyIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :company_id, :integer
  end
end
