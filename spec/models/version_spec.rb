require 'spec_helper'

describe Version do
  context 'relationships' do
    it { should belong_to(:activity) }
    it { should belong_to(:trackable) }
    it { should have_many(:version_changes) }
  end
end