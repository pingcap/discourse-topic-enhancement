# name: DiscourseTopicEnhancement
# about:
# version: 0.1
# authors: hooopo
# url: https://github.com/hooopo


register_asset "stylesheets/common/discourse-topic-enhancement.scss"


enabled_site_setting :discourse_topic_enhancement_enabled

PLUGIN_NAME ||= "DiscourseTopicEnhancement".freeze

after_initialize do
  
  # see lib/plugin/instance.rb for the methods available in this context
  

  module ::DiscourseTopicEnhancement
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace DiscourseTopicEnhancement
    end
  end

  add_to_class(:topic, :enhancement?) do 
    custom_fields['urged_by_organization'] == 'true'
  end

  add_to_class(:user, :verified?) do
    custom_fields['verified'] == 'true'
  end

  add_to_serializer(:topic_view, :is_enhancement) do
    topic.enhancement?
  end

  add_to_serializer(:listable_topic, :is_enhancement) do
    object.enhancement?
  end

  add_to_serializer(:basic_user, :is_verified) do
    user.verified?
  end

  add_to_serializer(:user, :is_verified) do
    user.verified?
  end

  add_to_serializer(:user_badge, :is_verified) do
    user.verified?
  end

  add_to_serializer(:post, :user_is_verified) do 
    object.user&.verified?
  end

  add_to_serializer(:user_action, :user_is_verified) do
    User.where(id: user_id).first&.verified?
  end

  add_to_serializer(:draft, :user_is_verified) do
    User.where(id: user_id).first&.verified?
  end

  add_to_serializer(:user_action, :acting_user_is_verified) do 
    User.where(id: acting_user_id).first&.verified?
  end

  add_to_serializer(:topic_list_item, :is_enhancement) do
    object.enhancement?
  end

  TopicList.preloaded_custom_fields << "urged_by_organization"
  CategoryList.preloaded_topic_custom_fields << "urged_by_organization"

  
  require_dependency "application_controller"
  class DiscourseTopicEnhancement::ActionsController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    before_action :ensure_logged_in

    def list
      render json: success_json
    end
  end

  DiscourseTopicEnhancement::Engine.routes.draw do
    get "/list" => "actions#list"
  end

  Discourse::Application.routes.append do
    mount ::DiscourseTopicEnhancement::Engine, at: "/discourse-topic-enhancement"
  end
  
end
