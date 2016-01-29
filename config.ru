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

  use Rack::Auth::Basic do |username, password|
    users = @@project.reduce({}) do |result, (_, data)|
      data["credentials"].each do |name, pwd|
        result[name] = pwd
      end
    end
    users[username] == password
  end

  get "/:client/" do |client|
    "#{client} " + (@@project[client] ? "exists." : "does not exist.")
  end
end

YAML.load_file("config.yaml").each do |project|
  ClientCMS.add_project(project)
end

run ClientCMS
