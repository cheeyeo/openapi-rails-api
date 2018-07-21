ActiveModel::Serializer.config.adapter = ActiveModelSerializers::Adapter::JsonApi

# Refer to <active_model_serializers_gem>/lib/active_model_serializers/railitie.rb line 18; AMS sets the SerializationContext.default_url_options = Rails.application.routes.default_url_options so need to set it per env
Rails.application.routes.default_url_options = Rails.application.config.action_mailer.default_url_options
