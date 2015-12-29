class CMSArticles
  class Jekyll
    def self.dump(frontmatter, content)
      require "yaml"
      YAML.dump(frontmatter) + "---\n" + content
    end

    def self.list(project_path)
      %w[_drafts _posts].reduce([]) do |t, dir|
        pathname = "#{project_path}/#{dir}/"
        files = Dir.entries(pathname).find_all do |filename|
          %w[.md .markdown].include?(File.extname(filename))
        end
        t + files.sort.collect do |filename|
          CMSArticles::Jekyll.new(pathname + filename)
        end
      end
    end

    def self.load(text)
      data = text.split(/^---\n/)
      data.shift
      frontmatter = YAML.load(data.shift)
      content = data.join("---\n")
      [frontmatter, content]
    end

    attr_accessor :content, :filename, :frontmatter

    def initialize(filename)
      @filename = filename
      @frontmatter, @content = CMSArticles::Jekyll.load(File.read(filename))
    end

    def save
      File.open(filename, "w") do |f|
        f.puts CMSArticles::Jekyll.dump(@frontmatter, @content)
      end
    end
  end
end

require "yaml"
CMSArticles::Jekyll.list(YAML.load_file("config.yaml")["path"]).each(&:save)
#puts CMSArticles::Jekyll.list(YAML.load_file("config.yaml")["path"]).collect(&:filename)
