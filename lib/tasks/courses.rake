namespace :courses do
  desc 'Update course information'
  task :update_courses => :environment do
    rails db:seed
  end
end
