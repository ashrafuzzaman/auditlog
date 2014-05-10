require 'spec_helper'

describe VersionChange do
  context 'relationships' do
    it { should belong_to(:version) }
    it { should have_many(:change_notifications) }
  end

  context 'i18n methods' do
    subject do
      change = VersionChange.new
      change.version = Version.new
      change.version.trackable = WorkflowStatus.new
      change.field = 'title'
      change
    end
    its(:table_name) { should eq 'workflow_status' }
    its(:i18n_prefix) { should eq 'auditlog.models.workflow_status.title' }
    its(:i18n_default_prefix) { should eq 'auditlog.models.title' }
  end
end