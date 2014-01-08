require 'fileutils'
require 'socket'

class PowApp
  
  attr_reader :name, :path, :source_path, :url, :xip_url
  
  POW_PATH = File.expand_path('~/.pow')
  
  def initialize(attributes = {})
    @name = attributes[:name]
    @path = attributes[:path]
    @source_path = attributes[:source_path]
    @url = "http://#{name}.dev"
    @xip_url = "http://#{name}.#{PowApp.local_ip}.xip.io"
  end
  
  def create!
    unless name.nil? || source_path.nil?
      # Create the pow link
      FileUtils.ln_s(source_path, "#{POW_PATH}/#{name}")
    end
    true
  rescue Errno::EEXIST
    true
  rescue
    false
  end
  
  def browse
    %x{open #{url}}
  end
  
  def destroy
    if File.exists?(path)
      FileUtils.rm(path)
      true
    else
      false
    end
  end
  
  def restart
    FileUtils.mkdir_p("#{path}/tmp")
    FileUtils.touch("#{path}/tmp/restart.txt")
  end
  
  def self.find(pow_path)
    if File.directory? pow_path
      pow_app = PowApp.new({
        :name => File.basename(pow_path),
        :path => pow_path
      })
    end
    pow_app
  end
  
  def self.search(keyword=nil)
    apps = []
    if keyword.nil? || keyword == ""
      found_apps = all_pow_apps
    else
      found_apps = all_pow_apps.select { |app| app.match keyword }
    end
    found_apps.each do |app|
      pow_app = find(File.expand_path(app, POW_PATH))
      apps << pow_app unless pow_app.nil?
    end
    apps
  end

  def self.all_pow_apps 
    @all_apps ||= begin
      Dir.chdir(POW_PATH)
      Dir.glob('*')
    end
    @all_apps
  end
  
  def self.local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily
    UDPSocket.open do |s|
      # We're using Google's IP, but we don't actually make a connection or send anything
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end
  
end