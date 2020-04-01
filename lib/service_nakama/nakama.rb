module ServiceNakama

  def self.included(included_klass)
    included_klass.class_eval do
      attr_reader :result, :error
      extend ClassMethods
      main_method :perform
    end
  end

  def success?
    @error.nil?
  end

  alias success success?

  def failed?
    !success?
  end

  alias failed failed?

  def error_logger
    puts "Exception Handled From Service Class(#{error_class}: #{error_message})"
  end

  def error_message
    @error.message
  end

  def error_class
    @error.class
  end

  def raise_not_implemented(method)
    raise NotImplementedError, "Implement the '#{method}' method to your Service Class"
  end

  module ClassMethods
    def main_method(method = :perform)
      method = method.to_sym if method.is_a? String
      define_method(method) { raise_not_implemented method }

      define_main_singleton_method method
    end

    private

    def define_main_singleton_method(method)
      define_singleton_method method do |*args|
        new(*args).tap do |service|
          begin
            service.instance_variable_set('@result', service.public_send(method))
          rescue => e
            service.instance_variable_set('@error', e)
            service.error_logger
          end
        end
      end
    end
  end
end