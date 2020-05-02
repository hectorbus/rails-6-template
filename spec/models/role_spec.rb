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

require 'rails_helper'

RSpec.describe Role, type: :model do
  before(:example) do
    @role = build(:role)
  end

  context 'with valid attributes' do
    it 'has a valid role' do
      expect(@role).to be_valid
    end

    it 'has relation to permissions' do
      expect(@role).to have_many(:permissions)
    end
  end

  context 'with invalid attributes' do
    it 'has an error when name is empty' do
      @role.name = nil
      expect(@role).not_to be_valid
    end

    it 'has an error when description is empty' do
      @role.description = nil
      expect(@role).not_to be_valid
    end

    it 'has an error when description is scope' do
      @role.scope = nil
      expect(@role).not_to be_valid
    end
  end

  context 'with no unique fields in role' do
    it 'has unique key' do
      @role.save
      role2 = build(:role, name: 'Admin', description: 'Administrador del sistema.', scope: 0)
      expect(role2).not_to be_valid
    end
  end

  it 'is audited' do
    expect(@role).to be_audited
  end

  context 'when created' do
    it 'triggers audit creation' do
      expect{@role.save}.to change(Audited::Audit, :count).by(1)
    end
  end

  context 'when updating' do
    before(:example) do
      @role.save
    end

    context 'name' do
      it 'triggers audit creation' do
        expect{@role.update(name: 'Admin')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'key' do
      it 'triggers audit creation' do
        expect{@role.update(key: 'admin')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'description' do
      it 'triggers audit creation' do
        expect{@role.update(description: 'Administrador del sistema')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'scope' do
      it 'triggers audit creation' do
        expect{@role.update(scope: 'total')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'created_at' do
      it 'does not trigger audit creation' do
        expect{@role.update(created_at: Time.now)}.to_not change(Audited::Audit, :count)
      end
    end

    context 'updated_at' do
      it 'does not trigger audit creation' do
        expect{@role.update(updated_at: Time.now)}.to_not change(Audited::Audit, :count)
      end
    end
  end

  context 'when assigning a permission' do
    it 'triggers audit creation' do
      permission = create(:permission)
      @role.save
      expect{@role.permissions << permission}.to change(Audited::Audit, :count).by(1)
    end
  end

  context 'when deassigning a permission' do
    it 'triggers audit creation' do
      permission = create(:permission)
      @role.save
      @role.permissions << permission
      expect{@role.permissions.delete(permission)}.to change(Audited::Audit, :count).by(1)
    end
  end

  context 'when destroyed' do
    it 'triggers audit creation' do
      @role.save
      expect{Role.destroy(@role.id)}.to change(Audited::Audit, :count).by(1)
    end
  end
end
