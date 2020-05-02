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

FactoryBot.define do
  factory :role do
    name 'Default'
    key 'default'
    description 'Usuario default del sistema.'
    scope 'owner'

    trait :admin do
      name 'Admin'
      key 'admin'
      description 'Super administrador del sistema. Tiene acceso a todo.'
      scope 'total'
    end

    trait :with_accent do
      name 'Administración'
      key 'administración'
      description 'Administrador del sistema.'
    end

    trait :without_accent do
      name 'Administracion'
      key 'administracion'
      description 'Administrador del sistema.'
    end
  end
end
