module ServiceNakama

  def self.included(included_klass)
    included_klass.class_eval do
      attr_reader :result, :error
      extend ClassMethods
      main_method :perform
    end
  end

  def success?
    @error.blank?
  end

  alias success success?

  def failed?
    !success?
  end

  alias failed failed?

  def handle_error(error, status = 'rescue')
    @error = error

    raise @error if status == 'raise'
  end

  def error_message
    @error.message
  end

  def error_class
    @error.class
  end

  module ClassMethods
    def main_method(method_name = 'perform')
      method = method_name.to_sym
      define_main_instance_method method

      define_main_singleton_method method
    end

    private

    def define_main_instance_method(method)
      define_method method do
        raise NotImplementedError, "Implement the '#{method}' method to your Service Class"
      end
    end

    def define_main_singleton_method(method)
      define_singleton_method method do |*args|
        new(*args).tap do |service|
          begin
            service.instance_variable_set('@result', service.public_send(method))
          rescue => e
            service.handle_error(e)
          end
        end
      end
    end
  end
end