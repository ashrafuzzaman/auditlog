require 'spec_helper'
require 'auditlog/model_tracker'
require 'fake/active_record/models'

describe 'Integration' do
  context 'with selected columns' do
    before do
      @task = Task.create!(title: 'Test')
      @task.update_attributes(title: 'Test 1', hours_estimated: 10, assigned_to_id: 1)
    end

    it 'generates version with changes' do
      versions = @task.reload.versions
      versions.collect(&:event).should == ['create', 'update']
      changes(versions.first).should == [{:field => "title", :was => nil, :now => "Test"}]
      changes(versions.last).should == [{:field => "title", :was => "Test", :now => "Test 1"},
                                        {:field => "hours_estimated", :was => nil, :now => "10.0"},
                                        {:field => "assigned_to_id", :was => nil, :now => "1"}]
    end
  end
end

def changes(version)
  version.version_changes.collect { |c| {field: c.field, was: c.was, now: c.now} }
end