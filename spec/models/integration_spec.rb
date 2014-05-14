require 'spec_helper'

describe VersionChange do
  context 'with existing data' do
    before do
      @user = User.create!(first_name: 'Ashrafuz', last_name: 'zaman')
      Auditlog::Data.stub(:current_user_id) { @user.id }

      @project = Project.create!(name: 'Stubbles')

      @start = WorkflowStatus.create!(title: 'Start')
      @in_progress = WorkflowStatus.create!(title: 'In progress')
      @done = WorkflowStatus.create!(title: 'Done')

      @story1 = @project.stories.create!(title: 'Story 1', workflow_status_id: @start.id)
      @story2 = @project.stories.create!(title: 'Story 2', workflow_status_id: @in_progress.id)

      @task1 = @story1.tasks.create!(title: 'Task 1', workflow_status_id: @done.id)
    end

    it 'tracks the changes on create' do
      expect(@story1.versions.count).to be 1

      story1_version = @story1.versions.last
      expect(story1_version.event).to eq 'create'
      expect(story1_version.done_by).to eq @user
      expect(story1_version.project_id).to eq @project.id

      expect(@story1.version_changes.count).to be 2

      title_changes = @story1.version_changes.where(field: 'title').first
      expect(title_changes.was).to be nil
      expect(title_changes.now).to eq 'Story 1'

      workflow_status_changes = @story1.version_changes.where(field: 'workflow_status_id').first
      expect(workflow_status_changes.was).to be nil
      expect(workflow_status_changes.now).to eq @start.id.to_s
    end

    it 'tracks the changes on update' do
      @story1.title = "Something else"
      @story1.save!
      story1_version = @story1.versions.first
      expect(story1_version.event).to eq 'update'
      expect(story1_version.done_by).to eq @user
      expect(story1_version.project_id).to eq @project.id

      expect(story1_version.version_changes.count).to be 1

      change = story1_version.version_changes.first
      expect(change.was).to eq 'Story 1'
      expect(change.now).to eq 'Something else'
    end
  end
end