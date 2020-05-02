# == Schema Information
#
# Table name: roles
#
#  id          :bigint           not null, primary key
#  description :text
#  key         :string
#  name        :string
#  scope       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Role < ApplicationRecord
  has_many :users
  has_many :permissions_roles
  has_many :permissions, through: :permissions_roles, dependent: :destroy

  audited except: [:created_at, :updated_at]
  has_associated_audits

  enum scope: [:total, :owner]

  validates_presence_of :name, :key, :description, :scope
  validates_uniqueness_of :key, allow_blank: true

  ransacker :name, type: :string do
    Arel.sql('unaccent("name")')
  end

  ransacker :key, type: :string do
    Arel.sql('unaccent("key")')
  end

  # Adds I18n to scope enum values
  def self.i18n_scopes(hash = {})
    scopes.keys.each { |key| hash[I18n.t("scope.#{key}")] = key }
    hash
  end

end
