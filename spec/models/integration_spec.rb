require 'spec_helper'

describe VersionChange do
  context 'with existing data' do
    before do
      @project = Project.create!(name: 'Stubbles')

      start = WorkflowStatus.create!(title: 'Start')
      in_progress = WorkflowStatus.create!(title: 'In progress')
      done = WorkflowStatus.create!(title: 'Done')

      @story1 = @project.stories.create!(title: 'Story 1', workflow_status_id: start.id)
      @story2 = @project.stories.create!(title: 'Story 2', workflow_status_id: in_progress.id)

      @task1 = @story1.tasks.create!(title: 'Task 1', workflow_status_id: done.id)
    end

    it 'tracks the changes on create' do
      p @story1.versions
      p @story1.version_changes.inspect
    end
  end
end