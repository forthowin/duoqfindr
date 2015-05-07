require 'rails_helper'

describe RiotApi do
  describe RiotApi::Summoner do
    describe '.by_name' do
      context 'with valid summoner name' do
        it 'returns a valid summoner object from na region', :vcr do
          response = RiotApi::Summoner.by_name('forthwin', 'na')
          expect(response).to be_successful
        end

        it 'returns a valid summoner object from euw region', :vcr do
          response = RiotApi::Summoner.by_name('betongJocke', 'euw')
          expect(response).to be_successful
        end

        it 'URI escapes spaces in the summoner name', :vcr do
          response = RiotApi::Summoner.by_name('C9 Sneaky', 'na')
          expect(response).to be_successful
        end

        it 'URI escapes special characters in the summoner name', :vcr do
          response = RiotApi::Summoner.by_name('Hellø', 'na')
          expect(response).to be_successful
        end
      end

      context 'with invalid summoner name' do
        it 'returns an invalid object', :vcr do
          response = RiotApi::Summoner.by_name('forthwinggggg', 'na')
          expect(response).not_to be_successful
        end

        it 'returns an error message', :vcr do
          response = RiotApi::Summoner.by_name('forthwinggggg', 'na')
          expect(response.error_message).to be_present
        end
      end
    end
  end

  describe RiotApi::Summoner do
    describe '.runes' do
      it 'returns a valid rune pages object for valid summoner id', :vcr do
        response = RiotApi::Summoner.runes('23472148', 'na')
        expect(response).to be_successful
      end

      it 'returns an error message for invalid summoner id', :vcr do
        response = RiotApi::Summoner.runes('23472148234234', 'na')
        expect(response.error_message).to be_present
      end
    end
  end

  describe RiotApi::League do
    describe '.by_summoner_entry' do
      it 'returns valid league entries', :vcr do
        response = RiotApi::League.by_summoner_entry('23472148', 'na')
        expect(response).to be_successful
      end

      it 'returns an error message for invalid data', :vcr do
        response = RiotApi::League.by_summoner_entry('23472148234234', 'na')
        expect(response.error_message).to be_present
      end
    end
  end
end