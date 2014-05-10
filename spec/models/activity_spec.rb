require 'spec_helper'

describe Activity do
  context 'relationships' do
    it { should belong_to(:done_by) }
    it { should have_many(:versions) }
    it { should callback(:set_done_by_id).before(:save) }
  end

  describe '.set_done_by_id' do
    before do
      Auditlog::Data.stub(:current_user_id) { 1 }
      @activity = Activity.new
      @activity.send(:set_done_by_id)
    end
    subject { @activity }
    its(:done_by_id) { should eq 1 }
  end
end