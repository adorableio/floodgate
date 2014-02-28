require 'spec_helper'

module Floodgate
  describe Client, :vcr do
    let(:app_id) { '9d2852cff163507330242460c0ca5eec' }
    let(:api_token) { 'f28b5848e158f96e96168aa37f0002f2' }
    let(:status) { Client.status }

    before do
      Config.app_id = app_id
      Config.api_token = api_token
    end

    describe '.add_ip_address' do
      context 'when an ip address is specified' do
        let(:ip_address) { '1.1.1.1' }
        let(:params) do
          { ip_address: { ip_address: ip_address } }
        end

        before { Client.remove_ip_address(ip_address) }
        after { Client.remove_ip_address(ip_address) }

        it 'adds it to the list of allowed ip addresses' do
          expect { Client.add_ip_address(ip_address) }.to change { Client.allowed_ip_addresses.include?(ip_address) }.from(false).to(true)
        end
      end

      context 'when an ip address is not specified' do
        context 'and it is nil' do
          let(:ip_address) { nil }

          it' does not post' do
            expect(Client).not_to receive(:post)

            Client.add_ip_address(ip_address)
          end
        end

        context 'and it is empty' do
          let(:ip_address) { '' }

          it' does not post' do
            expect(Client).not_to receive(:post)

            Client.add_ip_address(ip_address)
          end
        end
      end
    end

    describe '.add_my_ip_address' do
      it 'adds my ip address to the list of allowed ip addresses' do
        expect(Client).to receive(:my_ip_address).and_return '1.1.1.1'
        expect(Client).to receive(:add_ip_address).with('1.1.1.1')

        Client.add_my_ip_address
      end
    end

    describe '.allowed_ip_addresses' do
      let(:ip_address) { '1.1.1.1' }

      before { Client.add_ip_address(ip_address) }
      after { Client.remove_ip_address(ip_address) }

      it 'returns the allowed ip addresses' do
        expect(Client.allowed_ip_addresses).to include(ip_address)
      end
    end

    describe '.close' do
      before { Client.open }

      it 'changes filter_traffic from false to true' do
        expect { Client.close }.to change { Client.status.filter_traffic }.from(false).to(true)
      end
    end

    describe '.my_ip_address' do
      it 'is an ip address' do
        ip_address = Client.my_ip_address
        expect { IPAddr.new(ip_address, Socket::AF_INET) }.not_to raise_error
      end
    end

    describe '.open' do
      before { Client.close }

      it 'changes filter_traffic from true to false' do
        expect { Client.open }.to change { Client.status.filter_traffic }.from(true).to(false)
      end
    end

    describe '.remove_ip_address' do
      context 'when an ip address is specified' do
        let(:ip_address) { '1.1.1.1' }
        let(:params) do
          { ip_address: { ip_address: ip_address } }
        end

        before { Client.add_ip_address(ip_address) }

        it 'removes it from the list of allowed ip addresses' do
          expect { Client.remove_ip_address(ip_address) }.to change { Client.allowed_ip_addresses.include?(ip_address) }.from(true).to(false)
        end
      end

      context 'when an ip address is not specified' do
        context 'and it is nil' do
          let(:ip_address) { nil }

          it' does not post' do
            expect(Client).not_to receive(:post)

            Client.remove_ip_address(ip_address)
          end
        end

        context 'and it is empty' do
          let(:ip_address) { '' }

          it' does not post' do
            expect(Client).not_to receive(:post)

            Client.remove_ip_address(ip_address)
          end
        end
      end
    end

    describe '.remove_my_ip_address' do
      it 'removes my ip address from the list of allowed ip addresses' do
        expect(Client).to receive(:my_ip_address).and_return '1.1.1.1'
        expect(Client).to receive(:remove_ip_address).with('1.1.1.1')

        Client.remove_my_ip_address
      end
    end

    describe '.set_redirect_url' do
      before { Client.set_redirect_url(initial_redirect_url) }

      context 'when a redirect_url is specified' do
        let(:initial_redirect_url) { nil }
        let(:redirect_url) { 'http://example.com' }

        it 'changes the redirect_url' do
          expect { Client.set_redirect_url(redirect_url) }.to change { Client.status.redirect_url }.from(initial_redirect_url).to(redirect_url)
        end
      end

      context 'when nil is specified' do
        let(:initial_redirect_url) { 'http://example.com' }
        let(:redirect_url) { nil }

        it 'clears the redirect_url' do
          expect { Client.set_redirect_url(redirect_url) }.to change { Client.status.redirect_url }
        end
      end
    end

    describe '.default_status' do
      it 'does not filter traffic' do
        expect(Client.default_status.filter_traffic).to be_false
      end

      it 'has a flag indicating that it is the default status' do
        expect(Client.default_status.default_status).to be_true
      end
    end

    describe '.status' do
      context 'when the credentials are not valid' do
        let(:app_id) { 'foo' }
        let(:api_token) { 'bar' }

        it 'returns the default status' do
          expect(status).to eq Client.default_status
        end
      end

      context 'when the credentials are valid' do
        context 'and traffic filtering is enabled' do
          let(:app_id) { 'fa5d63bcf3d6b557eee782c9e61e4002' }
          let(:api_token) { 'da2f2d06c102eea0f1971c2c90936ee3' }

          it 'filter_traffic is true' do
            expect(status.filter_traffic).to be_true
          end
        end

        context 'and traffic filtering is not enabled' do
          let(:app_id) { 'cbaeb13b7f63956ef70c382a7a67407d' }
          let(:api_token) { '349d2b1ee8ec56eb04b909b1eb9993b0' }

          it 'filter_traffic is false' do
            expect(status.filter_traffic).to be_false
          end
        end
      end
    end
  end
end

