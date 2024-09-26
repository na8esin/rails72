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

  # https://stackoverflow.com/questions/38445625/rspec-class-spy-on-rails-mailer
  context '.new' do
    it 'say Good morning' do
      double = class_spy(ExternalApi).as_stubbed_const
      mock_instance = instance_double("ExternalApi")

      allow(ExternalApi).to receive(:new) { mock_instance }

      allow(mock_instance).to receive(:fetch) { '' }

      described_class.new.fetch_external_with_initial_value

      expect(double).to have_received(:new).with(greet: "Good morning")
    end
  end
end
