class ChangeETokenDetailColumnName < ActiveRecord::Migration[5.0]
  def change
  	rename_column :e_token_details, :InstitutionTypes_id, :InstitutionType_id
  end
end
