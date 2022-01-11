##
# Download XML data from external sources
# Convert data to JSON and optionally save it to cache
#
# @author Derek Smart<derek@grindaga.com>
# @copyright 2018
# @license MIT

require 'json'
require 'rest-client'
require 'active_support'

module Jekyll_Xml_Source
  class Generator < Jekyll::Generator
    safe true
    priority :highest

    def saveToCache(data_source, name, content)
      path = "#{data_source}/#{name}.json"
      File.open(path,"w") do |file|
        file.write(content)
      end
    end

    def loadFromCache(data_source, name)
      path = "#{data_source}/#{name}.json"
      if not File.exist?(path)
        return
      end
      File.open(path,"r") do |file|
        return JSON.load(file.read())
      end
    end

    def generate(site)
      config = site.config['jekyll_xml']
      data_source = (site.config['data_source'] || '_data')

      if !config
        return
      end

      config.each do |data|
        if data['cache']
          site.data[data['data']] = loadFromCache(data_source, data['data'])
        end

        if site.data[data['data']].nil?
          begin
            result = RestClient::Request.execute method: :get, url: data['source'], user: ENV[data['auth_user']], password: ENV[data['auth_pass']]
            if data['json']
              site.data[data['data']] = result
            else
              site.data[data['data']] = JSON.load(Hash.from_xml(result).to_json)
            end
          rescue
            next
          end

          if data['cache']
            if data['json']
              saveToCache(data_source, data['data'], result)
            else
              saveToCache(data_source, data['data'], Hash.from_xml(result).to_json)
            end
            site.data[data['data']] = loadFromCache(data_source, data['data'])
          end
        end

      end

    end

  end
end