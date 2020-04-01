RSpec.describe ServiceNakama do

  let(:dummy_class) { Class.new {  include ServiceNakama } }
  let(:dummy_perform_class) do
    Class.new do
      include ServiceNakama

      def perform
        50
      end
    end
  end
  let(:dummy_error_class) do
    Class.new do
      include ServiceNakama
      ServiceClassError ||= Class.new(StandardError)

      def perform
        raise ServiceClassError, 'Error from service class!'
      end
    end
  end

  it 'has a version number' do
    expect(ServiceNakama::VERSION).not_to be nil
  end

  context 'when the service class performs' do
    context '#main_method is not found in class' do
      it 'is expected to raise error' do
        expect { dummy_class.perform }.to raise_error(NotImplementedError)
      end
    end

    context '#main_method is not specified from class' do
      it '#result is expected to be same as return of #perform' do
        service = dummy_perform_class.perform
        expect(service.result).to eq 50
      end
    end

    context '#main_method is given nil from class' do
      it '#result is expected to be same as return of #perform' do
        service = dummy_perform_class.perform
        expect(service.result).to eq 50
      end
    end

    context '#main_method #call is specified from class' do
      it '#result is expected to be same as return of #call' do
        dummy_class.class_eval do
          main_method :call

          def call
            50
          end
        end

        service = dummy_class.call
        expect(service.result).to eq 50
      end
    end

    context 'error raised from the class' do
      it '#error is expected to return the raised error' do
        service = dummy_error_class.perform
        expect(service.error.class).to eq ServiceClassError
      end

      it '#error_class is expected to return the raised error class' do
        service = dummy_error_class.perform
        expect(service.error.class).to eq ServiceClassError
      end

      it '#error_message is expected to return the raised error message' do
        service = dummy_error_class.perform
        expect(service.error.message).to eq 'Error from service class!'
      end

      it '#failed? is expected to return true' do
        service = dummy_error_class.perform
        expect(service.failed?).to eq true
        expect(service.failed).to eq true
      end

      it '#success? is expected to return false' do
        service = dummy_error_class.perform
        expect(service.success?).to eq false
        expect(service.success).to eq false
      end
    end

    context 'no error is given' do
      it '#failed? is expected to return false' do
        service = dummy_perform_class.perform
        expect(service.failed?).to eq false
        expect(service.failed).to eq false
      end

      it '#success? is expected to return true' do
        service = dummy_perform_class.perform
        expect(service.success?).to eq true
        expect(service.success).to eq true
      end
    end
  end
end
