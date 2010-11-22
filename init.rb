require 'redmine'

require 'dispatcher'

Dispatcher.to_prepare do
  require_dependency 'global_roles/roles_controller_patch'
  require_dependency 'global_roles/permission_patch'
  require_dependency 'global_roles/access_control_patch'
  require_dependency 'global_roles/role_patch'
  require_dependency 'global_roles/users_helper_patch'
end

Redmine::Plugin.register :redmine_global_roles do
  name 'Redmine Global Roles plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'

  if RAILS_ENV != "test"
    require_or_load 'global_roles/permission_patch'

    project_module :user do
      permission :manage_global_roles, {:example => [:say_hello]}, :global => true
    end
  end
end
