module Condfig
  class PageConfig
    def initialize(data)
      @data = data
    end

    def id
      @data['id']
    end

    def valid?(values = {})
      return false unless @data && @data.is_a?(Hash)

      values.each do |k, v|
        return false unless @data[k.to_s] && @data[k.to_s] == v
      end
      true
    end

    def to_json
      @data.to_json
    end
  end
end
