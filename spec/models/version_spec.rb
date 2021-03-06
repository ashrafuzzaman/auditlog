require 'spec_helper'

describe Version do
  context 'relationships' do
    it { should belong_to(:activity) }
    it { should belong_to(:trackable) }
    it { should have_many(:version_changes) }
    it { should callback(:set_done_by_id).before(:save) }
  end

  describe '.set_done_by_id' do
    before do
      Auditlog::Data.stub(:current_user_id) { 1 }
      @version = Version.new
      @version.send(:set_done_by_id)
    end
    subject { @version }
    its(:done_by_id) { should eq 1 }
  end
end