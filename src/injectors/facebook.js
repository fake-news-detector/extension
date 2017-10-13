import { getExternalLinkStory } from "./facebook/externalLinks.js";
import { getPagePost } from "./facebook/pagePost.js";
import { getSharePagePost } from "./facebook/sharePagePost.js";

export const notAdvertisement = userStory =>
  !!userStory.querySelector(".timestampContent");

export const notNested = userStory => !userStory.querySelector(".fbUserStory");

const findElementToRenderDetector = userStory =>
  getExternalLinkStory(userStory) ||
  getPagePost(userStory) ||
  getSharePagePost(userStory);

const markChecked = userStory => {
  userStory.classList.add("fnd-checked");
  return userStory;
};

const injectDetector = onInject => () =>
  [...document.querySelectorAll(".fbUserStory:not(.fnd-checked)")]
    .map(markChecked)
    .filter(notAdvertisement)
    .filter(notNested)
    .map(findElementToRenderDetector)
    .filter(a => a)
    .forEach(onInject);

let injectTimeout;
const injectOnFeedRefresh = onInject => {
  const observer = new MutationObserver(function(mutations) {
    clearTimeout(injectTimeout);
    injectTimeout = setTimeout(injectDetector(onInject), 100);
  });

  observer.observe(document.querySelector("#content_container"), {
    subtree: true,
    childList: true
  });
};

export default onInject => {
  if (!document.location.href.match("facebook.com")) return false;

  setInterval(injectDetector(onInject), 5000);
  injectOnFeedRefresh(onInject);
  injectDetector(onInject)();
};
