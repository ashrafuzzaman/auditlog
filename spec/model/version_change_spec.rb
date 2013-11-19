require 'spec_helper'
require 'auditlog/model_tracker'
require 'fake/active_record/models'

describe VersionChange do
  context '.for' do
    before do
      Task.destroy_all
      User.destroy_all

      @user = User.create!(name: 'Jitu')
      @project = Project.create!(title: 'Test')
      @task = Task.create!(title: 'Test', project_id: @project.id)
      @task.update_attributes(title: 'Test 1', hours_estimated: 10, assigned_to_id: 1)
    end

    it 'generates version with changes' do
      version_changes = VersionChange.for(field: :assigned_to_id, type: Task, id: @task.id)
      version_changes.should == [{:field => "title", :was => "Test", :now => "Test 1"},
                                 {:field => "hours_estimated", :was => nil, :now => "10.0"},
                                 {:field => "assigned_to_id", :was => nil, :now => "1"}]
    end
  end
end