# frozen_string_literal: true

RSpec.describe 'Version' do
  subject(:version) { VERSION }

  it { is_expected.to eq '0.3.1' }
end
