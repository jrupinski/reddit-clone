desc "Update URLS of Subs, Posts and Users to be reader-friendly"
task :update_models_with_friendly_url do
  User.find_each(&:save)
  Sub.find_each(&:save)
  Post.find_each(&:save)
  puts "Updated URLs successfully!"
end
