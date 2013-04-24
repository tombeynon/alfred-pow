require 'rubygems' unless defined? Gem
require "bundle/bundler/setup"
require "alfred"

require 'rexml/document'
require File.dirname(__FILE__) + '/lib/pow_app.rb'

class AlfredPow
  
  def self.create(source_path)
    app = PowApp.new({
      :name => File.basename(source_path),
      :source_path => source_path
    })
    if app.create!
      puts "#{app.name}.dev created successfully"
    else
      puts "Unable to create app"
    end
  end
  
  def self.browse(pow_path)
    if app = PowApp.find(pow_path)
      app.browse
      puts "#{app.name}.dev opened successfully"
    else
      puts "Unable to open app"
    end
  end
  
  def self.destroy(pow_path)
    if app = PowApp.find(pow_path)
      if app.destroy
        puts "#{app.name} destroyed successfully"
      else
        puts "Unable to destroy #{app.name}"
      end
    else
      puts "Couldn't find that app"
    end
  end
  
  def self.restart(pow_path)
    if app = PowApp.find(pow_path)
      app.restart
      puts "#{app.name}.dev restarted successfully"
    else
      puts "That app does not exist"
    end
  end
  
  def self.xip(pow_path)
    if app = PowApp.find(pow_path)
      puts app.xip_url
    else
      puts "That app does not exist"
    end
  end
  
  def self.environment(pow_path)
    if app = PowApp.find(pow_path)
      puts app.environment
    else
      puts "That app does not exist"
    end
  end

  def self.list(keyword)
    fb = alfred.feedback
    fb.add_item({
      :uid => "" ,
      :title => "Just a Test" ,
      :subtitle => "feedback item" ,
      :arg => "A test feedback Item" ,
      :valid => "yes" ,
    })

    # add an feedback to test rescue feedback
    fb.add_item({
      :uid => "" ,
      :title => "Rescue Feedback Test" ,
      :subtitle => "rescue feedback item" ,
      :arg => "" ,
      :autocomplete => "failed" ,
      :valid => "no" ,
    })
    puts fb.to_xml(ARGV)
    
    #found_apps = PowApp.search(keyword)
    #doc = REXML::Document.new
    #items = doc.add_element 'items'
    #found_apps.each do |app|
    #  item = items.add_element('item', {'uid' => app.name, 'arg' => app.path})
    #  item.add_element('title').add_text(app.name)
    #  item.add_element('subtitle').add_text(app.url)
    #  item.add_element('icon', {'type' => ''})
    #end
    #puts doc.to_s
  end

end