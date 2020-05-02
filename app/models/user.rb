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

class User < ApplicationRecord
  audited except: %i[created_at updated_at remember_created_at]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  belongs_to :role
  delegate   :scope, :key, :name, to: :role, prefix: true

  mount_uploader :avatar, AvatarUploader

  validates_presence_of :first_name, :last_name, :email

  after_update :recreate_avatar_thumb

  def admin?
    role and role.key == 'admin'
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  ransacker :first_name, type: :string do
    Arel.sql("unaccent(\"first_name\")")
  end

  ransacker :last_name, type: :string do
    Arel.sql("unaccent(\"last_name\")")
  end

  def recreate_avatar_thumb
    self.avatar.recreate_versions!(:thumb) if self.avatar?
  end

  def avatar_thumb
    self.avatar? ? self.avatar_url(:thumb) : 'missing.png'
  end
end
