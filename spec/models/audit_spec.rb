# == Schema Information
#
# Table name: audits
#
#  id              :bigint           not null, primary key
#  action          :string
#  associated_type :string
#  auditable_name  :string
#  auditable_type  :string
#  audited_changes :text
#  comment         :string
#  remote_address  :string
#  request_uuid    :string
#  user_full_name  :string
#  user_role_key   :string
#  user_type       :string
#  username        :string
#  version         :integer          default(0)
#  created_at      :datetime
#  associated_id   :integer
#  auditable_id    :integer
#  user_id         :integer
#
# Indexes
#
#  associated_index              (associated_type,associated_id)
#  auditable_index               (auditable_type,auditable_id,version)
#  index_audits_on_created_at    (created_at)
#  index_audits_on_request_uuid  (request_uuid)
#  user_index                    (user_id,user_type)
#

require 'rails_helper'

RSpec.describe Audit, type: :model do
  let(:role) {
    create(:role)
  }

  let(:user) {
    create(:user, :default, role: role)
  }

  context 'adding users information' do
    before(:example) do
      @permission = create(:permission)
    end
    it 'has the user full name' do
      expect(Audit.last.user_full_name).equal? (user.full_name)
    end

    it 'has the user full name' do
      expect(Audit.last.user_role_key).equal? (user.role_key)
    end

    it 'has the resources name' do
      expect(Audit.last.auditable_name).equal? (@permission.name)
    end
  end

  context 'changing permissions to roles' do
    before(:example) do
      @role = create(:role, :admin)
      @permission = create(:permission)
      create(:permissions_role, role: @role, permission: @permission)
    end

    it 'has the role name' do
      expect(Audit.last.audited_changes['role_name']).equal? (@role.name)
    end

    it 'has the permission name' do
      expect(Audit.last.audited_changes['permission_name']).equal? (@permission.name)
    end
  end

  context 'verifying logbooks timeline methods' do
    before(:example) do
      @admin_user = create(:user, role: create(:role, :admin))
      @logbook = Audit.order(created_at: :desc).first

      @logbook.current_user = user
      @logbook.update_attribute('user_id', user.id)
      @logbook.send(:set_audit_user_info)
      @logbook.send(:set_auditable_name)
      @logbook.save
    end

    it 'has partial icon' do
      expect(@logbook.logbook_icon).to include('fa-genderless')
    end

    it 'has partial table' do
      expect(@logbook.logbook_table).to include('Last_name')
      expect(@logbook.logbook_table).to include('First_name')
    end

    context 'verifing partial titles of logbooks' do
      it 'has title in first-person' do
        expect(@logbook.logbook_title).to include('Creaste')
      end

      it 'has title in third-person' do
        user = create(:user, :default2, role: role)
        @logbook.current_user = user
        expect(@logbook.logbook_title).to include('creó')
      end

      it 'has title in third-person when user logged in sees the logbook that shows him modified' do
        @logbook.current_user = @admin_user
        expect(@logbook.logbook_title).to include('creó tu cuenta')
      end
    end

    it 'convert to json a logbook with methods' do
      json = JSON.parse(Audit.convert_to_json(Audit.limit(3), user))
      expect(json.class).to eq(Array)
    end
  end

end
