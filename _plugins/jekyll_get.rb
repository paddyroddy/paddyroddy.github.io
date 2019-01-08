require 'json'
require 'hash-joiner'
require 'open-uri'

module Jekyll_Get
  class Generator < Jekyll::Generator
    safe true
    priority :highest

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
      config = site.config['jekyll_get']
      data_source = (site.config['data_source'] || '_data')
      if !config
        return
      end
      if !config.kind_of?(Array)
        config = [config]
      end
      config.each do |d|
        if d['cache']
          site.data[d['data']] = loadFromCache(data_source, d['data'])
        end
        if site.data[d['data']].nil?
          begin
            target = site.data[d['data']]
            source = JSON.load(open(d['json']))
            if target
              HashJoiner.deep_merge target, source
            else
              site.data[d['data']] = source
            end
            if d['cache']
              path = "#{data_source}/#{d['data']}.json"
              open(path, 'wb') do |file|
                file << JSON.generate(site.data[d['data']])
              end
            end
          rescue
            next
          end
        end
      end
    end
  end
end