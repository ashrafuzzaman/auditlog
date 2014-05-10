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

  describe '.i18n_message' do
    let(:version_change) do
      change = VersionChange.new
      change.version = Version.new
      change.version.trackable = WorkflowStatus.new
      change.field = 'title'
      change
    end
    [:set, :unset, :changed].each do |type|
      context "i18n_message with #{type.to_s}" do
        it 'returns i18n_message' do
          I18n.should_receive(:t).with(:"auditlog.models.workflow_status.title.#{type.to_s}", {default: [:"auditlog.models.title.#{type.to_s}"], was: 1, now: 2})
          version_change.send(:i18n_message, type, {was: 1, now: 2})
        end
      end

    end
  end

  describe '.readable_message' do
    class User < ActiveRecord::Base
      auditlog_name_as :name
    end

    class Story < ActiveRecord::Base
      belongs_to :assigned_to, :class_name => "User", :foreign_key => "assigned_to_id"
      track only: [:title, :assigned_to_id]
    end

    let(:version_change) do
      version_change = VersionChange.new
      version_change.version = Version.new
      story = Story.new
      version_change.version.trackable = story
      version_change
    end

    context "with association" do
      before do
        story = version_change.version.trackable
        story.assigned_to_id = User.create!(first_name: 'Ashraf', last_name: 'Zaman').id
        version_change.field = 'assigned_to_id'
        version_change.now = story.assigned_to_id
      end
      it 'returns readable_message' do
        I18n.should_receive(:t).with(:"auditlog.models.story.assigned_to_id.set", {default: [:"auditlog.models.assigned_to_id.set"], was: nil, now: "Ashraf Zaman"})
        version_change.readable_message
      end
    end

    context "with field" do
      before do
        story = version_change.version.trackable
        story.title = 'story 1'
        version_change.field = 'title'
        version_change.now = story.title
      end
      it 'returns readable_message' do
        I18n.should_receive(:t).with(:"auditlog.models.story.title.set", {default: [:"auditlog.models.title.set"], was: nil, now: 'story 1'})
        version_change.readable_message
      end
    end
  end
end