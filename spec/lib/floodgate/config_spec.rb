require 'spec_helper'

module Floodgate
  describe Config do
    before { Client.stub(:status).and_return json }

    let(:json) do
      {
        'filter_traffic' => filter_traffic,
        'redirect_url' => redirect_url
      }
    end

    let(:filter_traffic) { false }
    let(:redirect_url) { nil }
    let(:app_id) { 'abc123' }
    let(:api_token) { 'def456' }
    let(:config) { Config.new(app_id, api_token) }

    context 'when redirect_url is an empty string' do
      let(:filter_traffic) { false }
      let(:redirect_url) { '' }

      describe '#redirect?' do
        it 'is false' do
          expect(config.redirect?).to be_false
        end
      end
    end

    context 'when a redirect_url is specified' do
      let(:filter_traffic) { false }
      let(:redirect_url) { 'someurl' }

      describe '#redirect?' do
        it 'is true' do
          expect(config.redirect?).to be_true
        end
      end
    end
  end
end

