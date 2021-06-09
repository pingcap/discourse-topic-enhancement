import { withPluginApi } from "discourse/lib/plugin-api";

function initializeDiscourseTopicEnhancement(api) {
  
  // see app/assets/javascripts/discourse/lib/plugin-api
  // for the functions available via the api object
  console.log('discourse-topic-enhancement')
  
}

export default {
  name: "discourse-topic-enhancement",

  initialize() {
    withPluginApi("0.8.24", initializeDiscourseTopicEnhancement);
    
  }
};
