class Place < ApplicationRecord
  belongs_to :InstitutionTypes, optional: true
end
