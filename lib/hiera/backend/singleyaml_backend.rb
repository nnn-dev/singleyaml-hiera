class Hiera
  class Config
    class << self
      def config
        @config
      end
    end
  end

  module Backend
    class SingleYaml_backend
	  def initialize(cache=nil)
        require 'yaml'
        Hiera.debug("[singleyaml-hiera] SingleYaml backend starting")
		@file=get_option(:datafile,File.join(Hiera::Util.var_dir,'single.yaml'))
		raise Hiera::InvalidConfigurationError,"[singleyaml-hiera] cannot open #{@file}" unless File.exists?(@file)
		
        @cache = cache || Filecache.new
      end
      def lookup(key, scope, order_override, resolution_type, context)
        answer = nil
		
	    data = @cache.read_file(@file, Hash) do |data|
          YAML.load(data) || {}
        end
        keydata=data[key]
        Backend.datasources(scope, order_override) do |source|
		  path = Backend.parse_string("/#{source}", scope, extra_data={}, context={:recurse_guard => nil, :order_override => nil})
          Hiera.debug("[singleyaml-hiera] Looking for data source '#{source}' on '#{path}' for key '#{key}'")
          if (keydata.has_key?(path))
			answer = keydata[path]
			break if answer.nil?
            break if answer = Backend.parse_answer(keydata[path], scope, extra_data, context)
          end
        end
        return answer
      end
	  private
	  def get_option(name,default)
	    name=name.to_sym
		if Config[:singleyaml] && Config[:singleyaml][name]
          dir = Config[:singleyaml][name]
        else
          dir = default
        end

        if !dir.is_a?(String)
          raise(Hiera::InvalidConfigurationError,
                "[singleyaml-hiera] #{name} for :singleyaml cannot be an array")
        end
		
		dir
	  end
      
    end
  end
end