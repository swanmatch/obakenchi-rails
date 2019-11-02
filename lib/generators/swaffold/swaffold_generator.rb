require 'rails/generators/rails/scaffold/scaffold_generator'
class SwaffoldGenerator < Rails::Generators::ScaffoldGenerator
  # overwrite search action
  def add_resource_route
    return if options[:actions].present?

    # iterates over all namespaces and opens up blocks
    regular_class_path.each_with_index do |namespace, index|
      write("namespace :#{namespace} do", index + 1)
    end

    # inserts the primary resource
    #write("resources :\#{file_name.pluralize}", route_length + 1)
    write("resources :#{file_name.pluralize} do", route_length + 1)
    write("collection do", route_length + 2)
    write("match 'search', action: :index, as: :search, via: [:get, :post]", route_length + 3)
    write("end", route_length + 2)
    write("end\n", route_length + 1)

    # ends blocks
    regular_class_path.each_index do |index|
      write("end", route_length - index)
    end

    # route prepends two spaces onto the front of the string that is passed, this corrects that.
    # Also it adds a \\n to the end of each line, as route already adds that
    # we need to correct that too.
    route route_string[2..-2]
  end

  def main
    insert_into_file "app/views/layouts/application.html.erb", "<li class=\"nav-item\"><%= link_to #{class_name.singularize}.model_name.human, #{plural_table_name}_path, class: 'nav-link' %></li>\n", after: "<ul class=\"navbar-nav mr-auto\">\n"
    gsub_file "config/routes.rb", "  resources :#{file_name.pluralize}\n", ""
  end

  private
    def route_string
      @route_string ||= ""
    end

    def write(str, indent)
      route_string << "#{"  " * indent}#{str}\n"
    end

    def route_length
      regular_class_path.length
    end
end
