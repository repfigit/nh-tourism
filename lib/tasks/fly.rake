namespace :fly do
  desc "Prepare database and seed data for Fly.io deployment"
  task release: :environment do
    puts "Running database migrations..."
    Rake::Task["db:prepare"].invoke
    
    puts "Seeding database..."
    Rake::Task["db:seed"].invoke
    
    puts "Release tasks completed successfully!"
  end
end
