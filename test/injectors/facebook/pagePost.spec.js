import { expect } from "chai";
import { getPagePost } from "../../../src/injectors/facebook/pagePost";

describe("Page Post", () => {
  let userStory;

  describe("page post", () => {
    before(() => {
      userStory = userStoryFromFixture("facebook/postFromPage");
    });

    it("gets the post description as title", () => {
      expect(getPagePost(userStory).title).to.equal(
        "A Natura, dentre outras bizarrices, anuncia no Fantástico. Boicote neles!"
      );
    });

    it("gets the url from the original post", () => {
      expect(getPagePost(userStory).url).to.equal(
        "/mblivre/photos/a.204296283027856.1073741829.204223673035117/704540646336748/?type=3"
      );
    });

    it("gets the div where the image content lives to render the detector", () => {
      expect(getPagePost(userStory).elem).to.equal(
        document.querySelector("#this-one")
      );
    });
  });

  describe("profile post", () => {
    it("returns null because it is not a page post", () => {
      userStory = userStoryFromFixture("facebook/postFromProfile");
      expect(getPagePost(userStory)).to.equal(null);
    });
  });
});
