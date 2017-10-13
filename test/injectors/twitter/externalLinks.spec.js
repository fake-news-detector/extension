import { expect } from "chai";
import { getExternalLinkTweet } from "../../../src/injectors/twitter/externalLinks";

describe("External Links", () => {
  let userStory;

  describe("tweet with external links", () => {
    before(() => {
      userStory = tweetFromFixture("tweetWithEmbededLink");
      let iframeDocument = document.querySelector("iframe").contentWindow
        .document;
      iframeDocument.open();
      iframeDocument.write(loadFixture("twitter/embededLinkIframe"));
      iframeDocument.close();
    });

    it("gets the link title", () => {
      expect(getExternalLinkTweet(userStory).title).to.equal(
        "Finland Has Figured Out How to Combat Fake News. Full Frontal Thinks The U.S. Can Follow Suit."
      );
    });

    it("gets the url from the original post", () => {
      expect(getExternalLinkTweet(userStory).url).to.equal(
        "http://www.slate.com/blogs/browbeat/2017/10/12/full_frontal_investigates_finland_s_anti_fake_news_efforts_video.html?wpsrc=sh_all_dt_tw_bot"
      );
    });

    it("gets the div where the image content lives to render the detector", () => {
      expect(getExternalLinkTweet(userStory).elem).to.equal(
        document.querySelector("iframe").contentDocument.body
      );
    });
  });
});
