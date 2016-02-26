require 'spec_helper'

module Condfig
  describe ConfigRepository do
    it 'allows getting data' do
      expect(ConfigRepository.db).to receive(:get).with('foo')
      ConfigRepository.search('foo')
    end

    it 'allows storing data' do
      expect(ConfigRepository.db).to receive(:set).with('foo', 'some data')
      ConfigRepository.store('foo', 'some data')
    end

    it 'allows removing data' do
      expect(ConfigRepository.db).to receive(:del).with('foo')
      ConfigRepository.remove('foo')
    end
  end
end
