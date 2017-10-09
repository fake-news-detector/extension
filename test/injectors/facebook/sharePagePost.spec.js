import { expect } from "chai";
import { getSharePagePost } from "../../../src/injectors/facebook/sharePagePost";

describe("Share Page Post", () => {
  let userStory;

  describe("share page post", () => {
    before(() => {
      userStory = userStoryFromFixture("facebook/sharedPostFromPage");
    });

    it("gets the post description as title", () => {
      expect(getSharePagePost(userStory).title).to.equal(
        "Um escândalo sem precedentes.  Marcos Feliciano e combina com Jair Bolsonaro como ajudar Eduardo Cunha a entrar com pedido de impeachment sem correr risco de perderem o processo. No mesmo áudio Feliciano,admite que estaria com um grupo, blindando e salvando a pele de Eduardo Cunha, para que ele ajudasse a derrubar Dilma Rousseff."
      );
    });

    it("gets the url from the original post", () => {
      expect(getSharePagePost(userStory).url).to.equal(
        "/VerdadeSemManipulacao/videos/479313152193503/"
      );
    });

    it("gets the div where the image content lives to render the detector", () => {
      expect(getSharePagePost(userStory).elem).to.equal(
        document.querySelector("#this-one")
      );
    });
  });

  describe("share profile post", () => {
    it("returns null because it is not a page post", () => {
      userStory = userStoryFromFixture("facebook/sharedPostFromProfile");
      expect(getSharePagePost(userStory)).to.equal(null);
    });
  });
});
