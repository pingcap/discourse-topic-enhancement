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

  add_to_serializer(:topic_view, :is_enhancement) do
    topic.enhancement?
  end

  add_to_serializer(:topic_list_item, :is_enhancement) do
    object.enhancement?
  end

  TopicList.preloaded_custom_fields << "urged_by_organization"

  
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
