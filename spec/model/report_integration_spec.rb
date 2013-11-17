require 'spec_helper'
require 'auditlog/model_tracker'
require 'fake/active_record/models'

describe 'Integration' do
  context 'with selected columns' do
    before do
      @task = Task.create!(title: 'Test')
      @task.update_attributes(title: 'Test 1', hours_estimated: 10, assigned_to_id: 1)
    end
    subject { @task.reload.versions.collect(&:version_changes).flatten.collect{ |ch| {field: ch.field, was: ch.was, now: ch.now} } }

    it 'generates version' do
      subject.should == nil
    end
  end
end