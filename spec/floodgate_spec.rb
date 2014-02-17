require 'spec_helper'

module Floodgate
  describe Control do
    let(:app) { double().as_null_object }
    let(:control) { described_class.new(app) }
    let(:env) { Hash.new }

    before do
      ENV['FLOODGATE_FILTER_TRAFFIC'] = ''
      ENV['MAINTENANCE_PAGE_URL'] = ''
    end

    after do
      ENV['FLOODGATE_FILTER_TRAFFIC'] = ''
      ENV['MAINTENANCE_PAGE_URL'] = ''
    end

    describe '#call' do
      it 'sends :call to the app with the specified environment' do
        expect(app).to receive(:call).with(env)
        control.call(env)
      end

      context 'when the floodgate is closed' do
        before { ENV['FLOODGATE_FILTER_TRAFFIC'] = 'closed' }

        let(:control) { described_class.new(app) }

        it 'does not send :call to the app' do
          expect(app).not_to receive(:call).with(env)
          control.call(env)
        end

        context 'when no maintenance page is specified in the environment' do
          before { ENV['MAINTENANCE_PAGE_URL'] = '' }

          it 'responds with a status of service unavailable' do
            expect(control.call(env)[0]).to eq(503)
          end

          it 'has an appropriate message in the response' do
            expect(control.call(env)[2]).to eq(['Application Unavailable'])
          end
        end

        context 'when a maintenance page is specified in the environment' do
          before { ENV['MAINTENANCE_PAGE_URL'] = 'someurl' }

          it 'redirects with a temporary redirect status' do
            expect(control.call(env)[0]).to eq(307)
          end

          it 'has a location set to the maintenance page' do
            expect(control.call(env)[1]['Location']).to eq('someurl')
          end
        end
      end
    end

    describe '#filter_traffic?' do
      it 'returns false by default' do
        expect(control.filter_traffic?).to eq(false)
      end

      context 'when traffic filtering is enabled in the environment' do
        before { ENV['FLOODGATE_FILTER_TRAFFIC'] = 'closed' }

        it 'returns true' do
          expect(control.filter_traffic?).to eq(true)
        end

        after { ENV['FLOODGATE_FILTER_TRAFFIC'] = nil }
      end
    end

    describe '#redirect?' do
      it 'is false by default' do
        expect(control.redirect?).to eq(false)
      end

      context 'when the redirect url is an empty string' do
        before { control.stub(:redirect_url).and_return '' }

        it 'is false' do
          expect(control.redirect?).to eq(false)
        end
      end

      context 'when the redirect url is a string' do
        before { control.stub(:redirect_url).and_return 'someurl' }

        it 'is true' do
          expect(control.redirect?).to eq(true)
        end
      end
    end

    describe '#redirect_url' do
      context 'when a maintenance page is specified in the environment' do
        before { ENV['MAINTENANCE_PAGE_URL'] = 'someurl' }

        it 'returns the maintenance page url' do
          expect(control.redirect_url).to eq('someurl')
        end

        after { ENV['MAINTENANCE_PAGE_URL'] = '' }
      end
    end
  end
end
