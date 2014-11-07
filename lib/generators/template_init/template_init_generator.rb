class TemplateInitGenerator < Rails::Generators::Base
  argument :new_name, :required => true
  
  def rename_app
    gsub_file Rails.root.join('config/application.rb'), 'Template', new_name.camelcase
    gsub_file Rails.root.join('config/database.yml'), 'template', new_name.underscore
    gsub_file Rails.root.join('config/initializers/session_store.rb'), 'template', new_name.underscore
  end

  def git_stuff
    git :checkout => "--orphan master"
    git :add => "."
    git :commit => "-m 'init import'"
    git :branch => "-D template"
    git :remote => "rm origin"
  end
end
