class ErrorSerializer
  attr_reader :code

  def initialize(code, exception)
    @code = code
    @exception = exception
  end

  def serialize
    [{
      status: code,
      source: { pointer: '' },
      title: title,
      detail: @exception.message
    }]
  end

  private

  def title
    I18n.t(
      @code,
      scope: [:errors, :titles],
      locale: :api,
      default: 'Error'
    )
  end

  def code
    I18n.t(
      @code,
      scope: [:errors, :codes],
      locale: :api,
      default: '404'
    )
  end
end
