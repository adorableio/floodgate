require 'spec_helper'

module Floodgate
  describe Config do
    context 'when no arguments are specified' do
      let(:config) { Config.new }

      it 'defaults filter_traffic to false' do
        expect(config.filter_traffic).to be_false
      end

      it 'defaults redirect_url to nil' do
        expect(config.redirect_url).to be_nil
      end
    end

    context 'when redirect_url is an empty string' do
      let(:config) { Config.new(filter_traffic, redirect_url) }
      let(:filter_traffic) { false }
      let(:redirect_url) { '' }

      describe '#redirect?' do
        it 'is false' do
          expect(config.redirect?).to be_false
        end
      end
    end

    context 'when a redirect_url is specified' do
      let(:config) { Config.new(filter_traffic, redirect_url) }
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

