require 'spec_helper'

module Floodgate
  describe Control do
    let(:app) { double().as_null_object }
    let(:control) { described_class.new(app) }
    let(:ENV) { Hash.new }

    describe '#call' do
      it 'sends :call to the app with the specified environment' do
        expect(app).to receive(:call).with(ENV)
        control.call(ENV)
      end

      context 'when the floodgate is closed' do
        before { ENV['FLOODGATE_FILTER_TRAFFIC'] = 'closed' }

        let(:control) { described_class.new(app) }

        it 'does not send :call to the app' do
          expect(app).not_to receive(:call).with(ENV)
          control.call(ENV)
        end

        context 'when a maintenance page is specified in the environment' do
          before { ENV['MAINTENANCE_PAGE_URL'] = 'someurl' }

          it 'redirects with a temporary redirect status' do
            expect(control.call(ENV)[0]).to eq(307)
          end

          it 'has a location set to the maintenance page' do
            expect(control.call(ENV)[1]['Location']).to eq('someurl')
          end
        end

        context 'when no maintenance page is specified in the environment' do
          it 'responds with a status of service unavailable' do
            expect(control.call(ENV)[0]).to eq(503)
          end

          it 'has an appropriate message in the response' do
            expect(control.call(ENV)[2]).to eq(['Application Unavailable'])
          end
        end
      end
    end
  end
end
