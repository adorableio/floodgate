require 'spec_helper'

module Floodgate
  describe Client do
    let(:json) { Client.status(app_id, api_token) }

    describe '.status' do
      context 'when the credentials are not valid' do
        let(:app_id) { 'foo' }
        let(:api_token) { 'bar' }

        it 'is an error' do
          expect { json }.to raise_error(OpenURI::HTTPError)
        end
      end

      context 'when the credentials are valid' do
        context 'and traffic filtering is enabled' do
          let(:app_id) { 'fa5d63bcf3d6b557eee782c9e61e4002' }
          let(:api_token) { 'da2f2d06c102eea0f1971c2c90936ee3' }

          it 'filter_traffic is true' do
            expect(json['filter_traffic']).to be_true
          end
        end

        context 'and traffic filtering is not enabled' do
          let(:app_id) { 'cbaeb13b7f63956ef70c382a7a67407d' }
          let(:api_token) { '349d2b1ee8ec56eb04b909b1eb9993b0' }

          it 'filter_traffic is false' do
            expect(json['filter_traffic']).to be_false
          end
        end
      end
    end
  end
end
