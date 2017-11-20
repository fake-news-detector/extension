import { expect } from "chai";
import {
  getExternalLinkStory,
  getExternalUrl
} from "../../../src/injectors/facebook/externalLinks";

describe("External Links", () => {
  let userStory;

  describe("post with external links", () => {
    before(() => {
      userStory = userStoryFromFixture("postWithExternalLink");
    });

    it("gets the link title", () => {
      expect(getExternalLinkStory(userStory).title).to.equal(
        "O dia em que Adriane Galisteu e Faustão estrelaram uma videocassetada ao vivo na TV"
      );
    });

    it("gets the external url", () => {
      expect(getExternalLinkStory(userStory).url).to.equal(
        "http://huffp.st/2ynax3o"
      );
    });

    it("gets the div where the image content lives to render the detector", () => {
      expect(getExternalLinkStory(userStory).elem).to.equal(
        document.querySelector("#this-one")
      );
    });
  });

  describe("post with internal links", () => {
    it("returns null because it is not an external link", () => {
      userStory = userStoryFromFixture("sharedPostFromPage");
      expect(getExternalLinkStory(userStory)).to.equal(null);
    });
  });

  describe("getExternalUrl", () => {
    it("returns the url if it is not a facebook one", () => {
      const a = { href: "http://www.pudim.com.br" };
      expect(getExternalUrl(a)).to.equal(a.href);
    });

    it("extracts external link out of facebook's wrapper", () => {
      let a = {};
      a.href =
        "https://l.facebook.com/l.php?u=https%3A%2F%2Ftecnoblog.net%2F224816%2Frumor-preco-iphone-8-plus-brasil%2F&h=ATPUoAPZS7_4ovGV7USWGOosDT_5NhE1bYLryDQKKfgt03fwcna46IbFp1CItisdDKszIIV5JfaDe9oifkpB2kdUpRQLF9AsnoXCjD9POpKrKYmrAb6cFjNtRbzZryhYOs7aygRS_bI-VUu8IfF801fPixhsajw9w7qFjSZjdjTQfUohtPKwS8Q-zor81wKNdqbWHUSLZcwCFrf8TDUELQdeHuwxJngRiWTz1d1W3dBYQqHA_Wcud__TVhpfjzAS2pBeYlbf4vXyH2HdfcQ6k0YrC2v4aBb1HWwDGw";

      expect(getExternalUrl(a)).to.equal(
        "https://tecnoblog.net/224816/rumor-preco-iphone-8-plus-brasil/"
      );
    });

    it("returns null for facebook urls", () => {
      const a = { href: "http://facebook.com/pudim" };
      expect(getExternalUrl(a)).to.equal(null);
    });

    it("returns null for relative urls", () => {
      const a = { href: "#" };
      expect(getExternalUrl(a)).to.equal(null);
    });
  });

  describe.only("post from twitter", () => {
    before(() => {
      userStory = userStoryFromFixture("postFromTwitter");
    });

    it("gets the link title", () => {
      expect(getExternalLinkStory(userStory).title).to.equal("rai on Twitter");
    });

    it("gets the external url", () => {
      expect(getExternalLinkStory(userStory).url).to.equal(
        "https://twitter.com/raissaalmeida/status/931910705409937409/photo/1?utm_source=fb&utm_medium=fb&utm_campaign=gomex&utm_content=932300495623991296"
      );
    });

    it("gets the div where the image content lives to render the detector", () => {
      expect(getExternalLinkStory(userStory).elem).to.equal(
        document.querySelector("#this-one")
      );
    });
  });
});
