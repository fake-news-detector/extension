import { getExternalLinkStory } from "./facebook/externalLinks.js";
import { getPagePost } from "./facebook/pagePost.js";
import { getSharePagePost } from "./facebook/sharePagePost.js";

export default onInject => {
  const findElementToRenderDetector = userStory =>
    getExternalLinkStory(userStory) ||
    getPagePost(userStory) ||
    getSharePagePost(userStory);

  const notAdvertisement = userStory =>
    userStory.querySelector(".timestampContent");

  const notNested = userStory => !userStory.querySelector(".fbUserStory");

  const markChecked = userStory => {
    userStory.classList.add("fnd-checked");
    return userStory;
  };

  const injectDetector = () =>
    [...document.querySelectorAll(".fbUserStory:not(.fnd-checked)")]
      .map(markChecked)
      .filter(notAdvertisement)
      .map(findElementToRenderDetector)
      .filter(a => a)
      .forEach(onInject);

  let injectTimeout;
  const injectOnFeedRefresh = () => {
    const observer = new MutationObserver(function(mutations) {
      clearTimeout(injectTimeout);
      injectTimeout = setTimeout(injectDetector, 100);
    });

    observer.observe(document.querySelector("#content_container"), {
      subtree: true,
      childList: true
    });
  };

  setInterval(injectDetector, 5000);
  injectOnFeedRefresh();
  injectDetector();
};
