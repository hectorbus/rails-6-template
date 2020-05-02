# == Schema Information
#
# Table name: permissions
#
#  id          :bigint           not null, primary key
#  action      :string
#  controller  :string
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :permission do
    name 'Crear permiso'
    description 'Permite crear permiso'
    controller 'Permissions'
    action 'create'

    trait :users do
      controller 'Users::Registrations'
      action 'index'
    end

    trait :logbooks do
      controller 'Audits'
      action 'logbook_timeline'
    end

    trait :with_accent do
      name 'Crear permiso con puntuación'
      description 'Permite crear un permiso con puntuación'
    end

    trait :without_accent do
      name 'Borrar permiso sin puntuacion'
      description 'Permite borrar un permiso sin puntuacion'
      action 'destroy'
    end
  end
end
