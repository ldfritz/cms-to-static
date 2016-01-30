class CMSData
  class Jekyll
    def self.dump(data)
      require "yaml"
      YAML.dump(data)
    end

    def self.list(project_path)
      pathname = "#{project_path}/_data/"
      Dir.entries(pathname).find_all do |filename|
        %w[.yml .yaml .json .csv].include?(File.extname(filename))
      end.sort.collect do |filename|
        CMSData::Jekyll.new(pathname + filename)
      end
    end

    def self.load(data)
      require "yaml"
      YAML.load(data)
    end

    attr_accessor :data, :filename

    def initialize(filename)
      @filename = filename
      @data = CMSData::Jekyll.load(File.read(filename))
    end

    def save
      File.open(filename, "w") do |f|
        f.puts CMSData::Jekyll.dump(data)
      end
    end
  end
end

require "yaml"
#CMSData::Jekyll.files(YAML.load_file("config.yaml")["path"]).each(&:save)
puts CMSData::Jekyll.list(YAML.load_file("config.yaml")["path"]).collect(&:filename)
