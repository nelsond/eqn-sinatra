ROOT = File.expand_path(".", File.dirname(__FILE__)) unless defined? ROOT

task :environment do
  require "#{File.dirname(__FILE__)}/config/environment"
end

desc "Run application console"
task :console => :environment do
  system "irb -r '#{ROOT}/config/environment'"
end

desc "Show application routes"
task :routes do
  require "#{ROOT}/app"

  Eqn.routes.each do |verb, handlers|
    puts "#{verb}:\n"
    handlers.each do |handler|
      puts handler[0].source.to_s
    end
    puts "\n"
  end
end

desc "Ghetto autotest using kicker"
task :autotest do
  system "kicker --recipe ignore --execute 'rspec --tag ~slow' --notification --clear"
end
