require "yaml"
require "sinatra"
require "sinatra/base"

class ClientCMS < Sinatra::Base
  def self.add_project(p)
    @@project ||= {}
    @@project[p["name"]] = p
    @@project[p["name"]]["credentials"] = YAML.load_file(p["path"] + "/pwd")
    self
  end

#  use Rack::Auth::Basic do |username, password|
#    users = @@project.reduce({}) do |result, (_, data)|
#      data["credentials"].each do |name, pwd|
#        result[name] = pwd
#      end
#    end
#    users[username] == password
#  end

  get "/:client/*" do |client, route|
    render_file(format_path(client, route))
  end

  private
  def format_path(client, path)
    default_filename = "/index.html"
    path = "#{@@project[client]["path"]}/views/#{path}"
    path << default_filename if File.file?(path + default_filename)
    path.gsub!("//", "/")
  end

  def render_file(filename)
    if File.file?(filename)
      File.read(filename)
    else
      "#{viewpath} does not exist."
    end
  end
end

YAML.load_file("config.yaml").each do |project|
  ClientCMS.add_project(project)
end

run ClientCMS
