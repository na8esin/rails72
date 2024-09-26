require 'rails_helper'

RSpec.describe User, type: :model do
  context '#fetch_external' do
    it 'say welcom' do
      moc = instance_double(ExternalApi)

      allow(ExternalApi).to receive(:new).and_return(moc)
      allow(moc).to receive(:fetch).and_return('welcom')

      expect(described_class.new.fetch_external).to eq('welcom')
    end
  end
end
