class ValidationErrorsSerializer
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def serialize
    record.errors.details.map do |field, details|
      details.map do |error_details|
        ValidationErrorSerializer.new(record, field, error_details).serialize
      end
    end.flatten
  end
end
