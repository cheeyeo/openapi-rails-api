class ApplicationChecker
  def self.swagger_client?(client)
    client.application.name == 'Swagger UI' &&
      client.application.uid == Rails.application.credentials.oauth[:swagger][:client_id]
  end
end
