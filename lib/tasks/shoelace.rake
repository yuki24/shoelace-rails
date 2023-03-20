namespace :shoelace do
  namespace :icons do
    desc "Copy Shoelace icons to the assets path"
    task copy: :environment do
      cp_r Rails.root.join(Shoelace::Railtie.config.shoelace.dist_path, "assets").to_s, Rails.public_path
    end

    desc "Remove Shoelace icons"
    task clobber: :environment do
      rm_rf File.join(Rails.public_path, "assets/icons")
    end
  end
end

# Make sure `yarn install` is run before running `shoelace:icons:copy`.
if Rake::Task.task_defined?("javascript:build")
  Rake::Task["shoelace:icons:copy"].enhance(["javascript:build"])
end

if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance(["shoelace:icons:copy"])
end
