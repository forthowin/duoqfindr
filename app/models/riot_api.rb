module RiotApi
  class Summoner
    attr_accessor :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.by_name(summoner_name, region)
      begin
        response = JSON.parse(open(URI.escape("https://#{region}.api.pvp.net/api/lol/#{region}/v1.4/summoner/by-name/#{summoner_name}?api_key=#{ENV['RIOT_API_KEY']}")).read)
        new(response: response)
      rescue OpenURI::HTTPError => e
        new(error_message: e.message)
      end
    end

    def self.runes(summoner_id, region)
      begin
        response = JSON.parse(open("https://#{region}.api.pvp.net/api/lol/#{region}/v1.4/summoner/#{summoner_id}/runes?api_key=#{ENV['RIOT_API_KEY']}").read)
        new(response: response)
      rescue OpenURI::HTTPError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end

  class League
    attr_accessor :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.by_summoner_entry(summoner_id, region)
      begin
        response = JSON.parse(open("https://#{region}.api.pvp.net/api/lol/#{region}/v2.5/league/by-summoner/#{summoner_id}/entry?api_key=#{ENV['RIOT_API_KEY']}").read)
        new(response: response)
      rescue OpenURI::HTTPError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end
end
