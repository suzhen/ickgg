require "thor"
require "active_support/inflector"

module Ickgg
  class Command < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__)
    end


    desc "new <app_name>","create a new project using grape on galiath"
    def new app_name
      @app_name = app_name.capitalize
      say "create a new application named #{app_name}", :green

      # create folder structure
      %w{app app/apis app/helpers app/entities app/models config config/environments config/initializers script log tmp lib spec spec/apis spec/entities spec/helpers}.each do |item|
        empty_directory app_name + "/" + item
      end


      # create basic files
      {
        application: "config/application.rb",
        database: "config/database.yml",
        redis: "config/redis.yml",
        spec_helper: "spec/spec_helper.rb",
        gemfile: "Gemfile",  
        # guardfile: "Guardfile",
        # rakefile: "Rakefile",
        engine: "script/engine.rb",
        rspec_config: ".rspec",
        server: "script/server.rb"
      }.each do |k, v|
        template("templates/#{k}.erb", "#{app_name}/#{v}")
      end

      inside app_name do
        run "bundle install"
      end

    end


    desc "s [options]", "start goliath server"
    method_option :port, :aliases => "-p", :desc => "server port"
    method_option :environment, :aliases => "-e", :desc => "server environment"
    method_option :pid, :aliases => "-P", :desc => "server pid path"
    method_option :log, :aliases => "-l", :desc => "server log path"
    method_option :daemon, :aliases => "-d", :desc => "run server as daemon"
    def s
      command = "ruby script/server.rb -p #{options[:port] || 3333} -e #{options[:environment] || 'development'}"

      if options[:log]
        command += " -l #{options[:log]}"
      else
        command += " -s"
      end
      if options[:pid]
        command += " -P #{options[:pid]}"
      end
      if options[:daemon]
        command += " -d"
      end

      exec command
    end

    desc "c", "start console"
    def c
      puts "starting console ..."
      require "pry"
      require "awesome_print"
      require "./script/server"
      Pry.start
      puts ""
    end

    desc "g", "generate files"
    def g g_type, g_name, *args
      @entity_name = g_name.include?("_") ? g_name.split("_").first : g_name
      @class_name = g_name.camelize
      case g_type
      when "entity"
        generate_entity g_name, args
      when "api"
        @resources_symbol = g_name.to_sym
        generate_api g_name, args
      else
        puts "invalid generator type"
      end
    end

    private

    def generate_entity name, *args
      template "templates/generator/entity.erb", File.join('app/entities', "#{name}.rb")
    end

    def generate_api name, *args
      template "templates/generator/api.erb", File.join('app/apis', "#{name}_api.rb")
    end

  end
end



