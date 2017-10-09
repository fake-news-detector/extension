import { expect } from "chai";
import { notNested, notAdvertisement } from "../../src/injectors/facebook";

describe("Facebook injector", () => {
  it("detects nested stories", () => {
    let userStory = userStoryFromFixture("facebook/nestedStory");
    expect(notNested(userStory)).to.equal(false);

    userStory = userStoryFromFixture("facebook/postFromPage");
    expect(notNested(userStory)).to.equal(true);
  });

  it("detects advertisement stories", () => {
    let userStory = userStoryFromFixture("facebook/advertisement");
    expect(notAdvertisement(userStory)).to.equal(false);

    userStory = userStoryFromFixture("facebook/postFromPage");
    expect(notAdvertisement(userStory)).to.equal(true);
  });
});
