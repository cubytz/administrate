require_relative "deferred"
require "active_support/core_ext/string/inflections"

module Administrate
  module Field
    class Base
      def self.with_options(options = {})
        Deferred.new(self, options)
      end

      def self.html_class
        field_type.dasherize
      end

      def self.searchable?
        false
      end

      def initialize(attribute, data, page, options = {})
        @attribute = attribute
        @data = data
        @page = page
        @resource = options.delete(:resource)
        @options = options
      end

      def self.permitted_attribute(attr, _options = nil)
        attr
      end

      def html_class
        self.class.html_class
      end

      def name
        attribute.to_s
      end

      def to_partial_path
        "/fields/#{self.class.field_type}/#{page}"
      end

      attr_reader :attribute, :data, :page, :resource

      def role
        @options[:role]
      end

      def required?
        self.resource._validators[self.name.to_sym].map(&:class).include?(ActiveRecord::Validations::PresenceValidator)
      end

      protected

      attr_reader :options

      def self.field_type
        to_s.split("::").last.underscore
      end
    end
  end
end
