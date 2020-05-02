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

require 'rails_helper'

RSpec.describe Permission, type: :model do

  context 'with valid attributes' do
    it 'has a valid permission' do
      expect(create(:permission)).to be_valid
    end

    it 'has relation to roles' do
      permission = create(:permission)
      expect(permission).to have_many(:roles)
    end
  end

  context 'with invalid attributes' do
    it 'have an error when name is empty' do
      expect(build(:permission, name: nil)).not_to be_valid
    end

    it 'have an error when description is empty' do
      expect(build(:permission, description: nil)).not_to be_valid
    end

    it 'have an error when action is empty' do
      expect(build(:permission, action: nil)).not_to be_valid
    end

    it 'have an error when controller is empty' do
      expect(build(:permission, controller: nil)).not_to be_valid
    end
  end

  context 'with no unique fields in permission' do
    it 'have unique name' do
      create(:permission)
      expect(build(:permission, description: 'Permite editar usuarios', action: 'edit', controller: 'users/registrations')).not_to be_valid
    end

    it 'have unique description' do
      create(:permission)
      expect(build(:permission, name: 'Editar usuarios', action: 'edit', controller: 'users/registrations')).not_to be_valid
    end

    it 'have unique combination of action and controller' do
      create(:permission)
      expect(build(:permission, name: 'Editar usuarios', description: 'Permite editar usuarios')).not_to be_valid
    end
  end

  it 'is audited' do
    expect(create(:permission)).to be_audited
  end

  context 'when created' do
    it 'triggers audit creation' do
      expect{create(:permission)}.to change(Audited::Audit, :count).by(1)
    end
  end

  context 'when updating' do
    before(:example) do
      @permission = create(:permission)
    end

    context 'name' do
      it 'triggers audit creation' do
        expect{@permission.update(name: 'Actualizar permiso')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'description' do
      it 'triggers audit creation' do
        expect{@permission.update(description: 'Permite actualizar un permiso.')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'action' do
      it 'triggers audit creation' do
        expect{@permission.update(action: 'update')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'controller' do
      it 'triggers audit creation' do
        expect{@permission.update(controller: 'Roles')}.to change(Audited::Audit, :count).by(1)
      end
    end

    context 'created_at' do
      it 'does not trigger audit creation' do
        expect{@permission.update(created_at: Time.now)}.to_not change(Audited::Audit, :count)
      end
    end

    context 'updated_at' do
      it 'does not trigger audit creation' do
        expect{@permission.update(updated_at: Time.now)}.to_not change(Audited::Audit, :count)
      end
    end
  end

  context 'when destroyed' do
    it 'triggers audit creation' do
      permission = create(:permission)
      expect{Permission.destroy(permission.id)}.to change(Audited::Audit, :count).by(1)
    end
  end
end
