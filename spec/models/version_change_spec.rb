require 'spec_helper'

describe VersionChange do
  context 'relationships' do
    it { should belong_to(:version) }
    it { should have_many(:change_notifications) }
    #it { should callback(:set_done_by_id).before(:save) }
  end
end