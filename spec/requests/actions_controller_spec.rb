require 'rails_helper'

describe DiscourseTopicEnhancement::ActionsController do
  before do
    Jobs.run_immediately!
  end

  it 'can list' do
    sign_in(Fabricate(:user))
    get "/discourse-topic-enhancement/list.json"
    expect(response.status).to eq(200)
  end
end
