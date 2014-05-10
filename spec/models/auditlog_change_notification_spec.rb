require 'spec_helper'

describe AuditlogChangeNotification do
  context 'relationships' do
    it { should belong_to(:version_change) }
    it { should belong_to(:model) }
  end
end