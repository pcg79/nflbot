namespace :db do
  task :set_env do
    ENV['RACK_ENV'] ||= "test"
  end

  desc "Example of task with invoke"
  task :migrate => :set_env do
    load "db/migrate.rb"
  end

  desc "Seed the database"
  task :seed => :set_env do
    load "db/seed.rb"
  end

  desc "Drop the tables"
  task :drop => :set_env do
    load "db/drop.rb"
  end

end
