# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role_id                :bigint
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role_id               (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#

FactoryBot.define do
  factory :user do
    email 'admin@example.com'
    password '12345678'
    password_confirmation '12345678'
    first_name 'Admin'
    last_name 'System User'
    confirmed_at Time.now
    role

    trait :default do
      email 'default@example.com'
      first_name 'Default'
      confirmed_at Time.now
      role
    end

    trait :default2 do
      email 'default2@example.com'
      first_name 'Default2'
      confirmed_at Time.now
      role
    end

    trait :with_accent do
      first_name 'Raúl'
    end

    trait :without_accent do
      first_name 'Raul'
    end

    trait :with_profile_picture do
      after(:build) do |user|
        user.avatar = File.open(Rails.root.join('spec', 'factories', 'images', 'user.png'))
      end
    end

    trait :unconfirmed do
      confirmed_at nil
      role
    end
  end
end
