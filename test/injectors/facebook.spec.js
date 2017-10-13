import { expect } from "chai";
import { notNested, notAdvertisement } from "../../src/injectors/facebook";

describe("Facebook injector", () => {
  it("detects nested stories", () => {
    let userStory = userStoryFromFixture("nestedStory");
    expect(notNested(userStory)).to.equal(false);

    userStory = userStoryFromFixture("postFromPage");
    expect(notNested(userStory)).to.equal(true);
  });

  it("detects advertisement stories", () => {
    let userStory = userStoryFromFixture("advertisement");
    expect(notAdvertisement(userStory)).to.equal(false);

    userStory = userStoryFromFixture("postFromPage");
    expect(notAdvertisement(userStory)).to.equal(true);
  });
});
