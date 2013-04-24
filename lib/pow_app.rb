require 'fileutils'
require 'socket'

class PowApp
  
  attr_reader :name, :path, :source_path, :url, :xip_url
  
  POW_PATH = File.expand_path('~/.pow')
  
  def initialize(attributes = {})
    @name = attributes[:name]
    @path = attributes[:path]
    @source_path = attributes[:source_path],
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
  
  def environment
    env = exec('osascript <<END
      tell application "Alfred 2"
      activate
      set alfredPath to (path to application "Alfred 2")
      set alfredIcon to path to resource "appicon.icns" in bundle (alfredPath as alias)
      display dialog "Enter the environment":" with title "Enter environment" buttons {"OK"} default button "OK" default answer "" with icon alfredIcon with hidden answer
      set answer to text returned of result
      end tell
    END');
    envfile = File.new(path + "/.powenv", "w")
    envfile.puts("export RAILS_ENV=#{env}")
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
  
  def self.search(keyword)
    apps = []
    found_apps = all_pow_apps.select { |app| app.match keyword }
    found_apps.each do |app|
      apps << find(File.expand_path(app, POW_PATH))
    end
    apps
  end

  def self.all_pow_apps 
    @all_apps ||= begin
      Dir.chdir(POW_PATH)
      Dir.glob('*')
    end
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