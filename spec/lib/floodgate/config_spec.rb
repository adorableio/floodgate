require 'spec_helper'

module Floodgate
  describe Config do
    before { Client.stub(:status).and_return json }

    let(:json) do
      {
        'allowed_ip_addresses' => allowed_ip_addresses,
        'filter_traffic' => filter_traffic,
        'redirect_url' => redirect_url,
      }
    end

    let(:allowed_ip_addresses) { [] }
    let(:filter_traffic) { false }
    let(:redirect_url) { nil }

    let(:app_id) { 'abc123' }
    let(:api_token) { 'def456' }
    let(:config) { Config.new(app_id, api_token) }

    describe '#client_allowed?' do
      context 'when the environment specifies the client address in REMOTE_ADDR' do
        let(:env) do
          {
            'REMOTE_ADDR' => ip_address
          }
        end

        context 'when the allowed ip address list is nil' do
          let(:allowed_ip_addresses) { nil }
          let(:ip_address) { '127.0.0.1' }

          it 'is false' do
            expect(config.client_allowed?(env)).to be_false
          end
        end

        context 'when the allowed ip address list is empty' do
          let(:allowed_ip_addresses) { [] }
          let(:ip_address) { '127.0.0.1' }

          it 'is false' do
            expect(config.client_allowed?(env)).to be_false
          end
        end

        context 'when there are allowed ip addresses' do
          let(:allowed_ip_addresses) { %w(198.81.129.107) }

          context 'and the specified ip address is in the list' do
            let(:ip_address) { '198.81.129.107' }

            it 'is true' do
              expect(config.client_allowed?(env)).to be_true
            end
          end

          context 'but the specified ip address is not in the list' do
            let(:ip_address) { '198.81.129.108' }

            it 'is false' do
              expect(config.client_allowed?(env)).to be_false
            end
          end
        end
      end

      context 'when the environment specifies the client address in HTTP_X_FORWARDED_FOR' do
        let(:env) do
          {
            'HTTP_X_FORWARDED_FOR' => ip_address
          }
        end

        context 'when the allowed ip address list is nil' do
          let(:allowed_ip_addresses) { nil }
          let(:ip_address) { '127.0.0.1' }

          it 'is false' do
            expect(config.client_allowed?(env)).to be_false
          end
        end

        context 'when the allowed ip address list is empty' do
          let(:allowed_ip_addresses) { [] }
          let(:ip_address) { '127.0.0.1' }

          it 'is false' do
            expect(config.client_allowed?(env)).to be_false
          end
        end

        context 'when there are allowed ip addresses' do
          let(:allowed_ip_addresses) { %w(198.81.129.107) }

          context 'and the specified ip address is in the list' do
            let(:ip_address) { '198.81.129.107' }

            it 'is true' do
              expect(config.client_allowed?(env)).to be_true
            end
          end

          context 'but the specified ip address is not in the list' do
            let(:ip_address) { '198.81.129.108' }

            it 'is false' do
              expect(config.client_allowed?(env)).to be_false
            end
          end
        end
      end
    end

    describe '#filter_traffic?' do
      context 'when filter_traffic is false' do
        let(:filter_traffic) { false }
        let(:env) { Hash.new }

        it 'is false' do
          expect(config.filter_traffic?(env)).to be_false
        end
      end

      context 'when filter_traffic is true' do
        let(:filter_traffic) { true }

        context 'and the ip address is not allowed' do
          let(:env) do
            {
              'REMOTE_ADDR' => '192.168.0.1'
            }
          end

          let(:allowed_ip_addresses) { %w(127.0.0.1) }

          it 'is true' do
            expect(config.filter_traffic?(env)).to be_true
          end
        end

        context 'and the ip address is allowed' do
          let(:env) do
            {
              'REMOTE_ADDR' => '127.0.0.1'
            }
          end

          let(:allowed_ip_addresses) { %w(127.0.0.1) }

          it 'is false' do
            expect(config.filter_traffic?(env)).to be_false
          end
        end
      end
    end

    describe '#redirect?' do
      context 'when redirect_url is nil' do
        let(:filter_traffic) { false }
        let(:redirect_url) { nil }

        it 'is false' do
          expect(config.redirect?).to be_false
        end
      end

      context 'when redirect_url is an empty string' do
        let(:filter_traffic) { false }
        let(:redirect_url) { '' }

        it 'is false' do
          expect(config.redirect?).to be_false
        end
      end

      context 'when a redirect_url is specified' do
        let(:filter_traffic) { false }
        let(:redirect_url) { 'someurl' }

        it 'is true' do
          expect(config.redirect?).to be_true
        end
      end
    end
  end
end

