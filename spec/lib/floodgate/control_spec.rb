require 'spec_helper'

module Floodgate
  describe Control do
    let(:app) { double().as_null_object }
    let(:control) { Control.new(app, app_id, api_token) }
    let(:env) { Hash.new }

    let(:app_id) { 'abc123' }
    let(:api_token) { 'def456' }

    let(:allowed_ip_addresses) { [] }
    let(:filter_traffic) { false }
    let(:redirect_url) { 'something' }

    let(:json) { Hashie::Mash.new(raw_json) }

    let(:raw_json) do
      {
        'allowed_ip_addresses' => allowed_ip_addresses,
        'filter_traffic' => filter_traffic,
        'redirect_url' => redirect_url
      }
    end

    before { Client.stub(:status).and_return json }

    describe '#call' do
      it 'sends :call to the app with the specified environment' do
        expect(app).to receive(:call).with(env)
        control.call(env)
      end

      context 'when the filter_traffic is true' do
        let(:filter_traffic) { true }

        it 'does not send :call to the app' do
          expect(app).not_to receive(:call).with(env)
          control.call(env)
        end

        context 'when no redirect url is specified' do
          let(:redirect_url) { nil }

          it 'responds with a status of service unavailable' do
            expect(control.call(env)[0]).to eq(503)
          end

          it 'has an appropriate message in the response' do
            expect(control.call(env)[2]).to eq(['Application Unavailable'])
          end
        end

        context 'when a redirect url is specified' do
          let(:redirect_url) { 'someurl' }

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
      it 'delegates to config' do
        expect(control.config).to receive(:filter_traffic?).with(env).and_return 'some boolean value'
        expect(control.filter_traffic?(env)).to eq 'some boolean value'
      end
    end

    describe '#redirect?' do
      it 'delegates to config' do
        expect(control.config).to receive(:redirect?).and_return 'some boolean value'
        expect(control.redirect?).to eq 'some boolean value'
      end
    end

    describe '#redirect_url' do
      it 'delegates to config' do
        expect(control.config).to receive(:redirect_url).and_return 'someurl'
        expect(control.redirect_url).to eq 'someurl'
      end
    end
  end
end
