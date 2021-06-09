import { acceptance } from "helpers/qunit-helpers";

acceptance("DiscourseTopicEnhancement", { loggedIn: true });

test("DiscourseTopicEnhancement works", async assert => {
  await visit("/admin/plugins/discourse-topic-enhancement");

  assert.ok(false, "it shows the DiscourseTopicEnhancement button");
});
