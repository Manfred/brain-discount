class ResourceController < ApplicationController
  class << self
    attr_accessor :accessible_attributes
  end

  before_filter :initialize_resource, only: %i(new create)
  before_filter :find_resource, only: %i(show edit update destroy)
  before_filter :set_resource_attributes, only: %i(create update)
  before_filter :save_resource, only: %i(create update)
  before_filter :destroy_resource, only: %i(destroy)

  private

  def resource_class_name
    self.class.name.gsub(/Controller$/, '').singularize
  end

  def resource_class
    resource_class_name.constantize
  end

  def resource_name
    resource_class_name.downcase
  end

  def resource_variable_name
    '@' + resource_name
  end

  def resource_params
    params.require(resource_name).permit(self.class.accessible_attributes)
  end

  def initialize_resource
    instance_variable_set(resource_variable_name, resource_class.new(resource_params))
  end

  def find_resource
    instance_variable_set(resource_variable_name, resource_class.find(params[:id]))
  end

  def resource_record
    instance_variable_get(resource_variable_name)
  end

  def set_resource_attributes
    resource_record.attributes = resource_params
  end

  def save_resource
    if resource_record.save
      redirect_to resource_record
    else
      render(params[:action] == 'create' ? :new : :edit)
    end
  end

  def destroy_resource
    resource_record.destroy
    redirect_to :index
  end
end

class BooksController < ResourceController
  self.accessible_attributes = %i(
    title
    description
  )
end
