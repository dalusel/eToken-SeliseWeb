class ETokenDetail < ApplicationRecord
  belongs_to :Places, optional: true
  belongs_to :Institutions, optional: true
  belongs_to :InstitutionTypes, optional: true
end
