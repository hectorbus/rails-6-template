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

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:example) do
    role = create(:role, :admin)
    @user = build(:user, role: role)
  end

  it 'is valid with valid attributes' do
    expect(@user).to be_valid
  end

  it 'is not valid without an email' do
    @user.email = nil
    expect(@user).to_not be_valid
  end

  it 'has a unique email' do
    @user.save
    user2 = build(:user, first_name: 'Example', last_name: 'User')
    expect(user2).to_not be_valid
  end

  it 'is not valid with an incorrect email format' do
    @user.email = 'email'
    expect(@user).to_not be_valid
  end

  it 'is not valid without a password' do
    user = build(:user, email: 'email@example.com', password: nil)
    expect(user).to_not be_valid
  end

  it 'is not valid with a password less than 6 characters long' do
    @user.password = '1234'
    expect(@user).to_not be_valid
  end

  it 'is not valid without first_name' do
    @user.first_name = nil
    expect(@user).to_not be_valid
  end

  it 'is not valid without last_name' do
    @user.last_name = nil
    expect(@user).to_not be_valid
  end

  it 'is not valid without a role' do
    @user.role = nil
    expect(@user).to_not be_valid
  end

  it 'is audited' do
    expect(@user).to be_audited
  end

  context 'when created' do
    it 'triggers audit creation' do
      expect{@user.save}.to change(Audited::Audit, :count).by(1)
    end
  end

  context 'when updating' do
    before(:example) do
      @user.save
    end

    context 'email' do
      it 'triggers audit creation' do
        expect{@user.update(email: 'email@example.com')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'first_name' do
      it 'triggers audit creation' do
        expect{@user.update(first_name: 'First name')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'last_name' do
      it 'triggers audit creation' do
        expect{@user.update(last_name: 'Last name')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'password' do
      it 'triggers audit creation' do
        expect{@user.update(password: 'password', password_confirmation: 'password')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'created at' do
      it 'does not trigger audit creation' do
        expect{@user.update(created_at: Time.now)}.to_not change(Audited::Audit, :count)
      end
    end

    context 'updated at' do
      it 'does not trigger audit creation' do
        expect{@user.update(updated_at: Time.now)}.to_not change(Audited::Audit, :count)
      end
    end
  end

  context 'when destroyed' do
    it 'triggers audit creation' do
      @user.save
      expect{User.destroy(@user.id)}.to change(Audited::Audit, :count).by(1)
    end
  end

  context 'with a valid image' do
    it 'saves the image' do
      @user = build(:user, :with_profile_picture)
      expect(@user.avatar?).to equal(true)
    end
  end
end
