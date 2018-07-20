class ValidationErrorsSerializer
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def serialize
    record.errors.details.map do |field, details|
      details.map do |detail|
        ValidationErrorSerializer.new(record, field, detail).serialize
      end
    end.flatten
  end
end
