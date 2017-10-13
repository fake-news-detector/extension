import { getExternalLinkTweet } from "./twitter/externalLinks";

const findElementToRenderDetector = tweet => getExternalLinkTweet(tweet);

const injectDetector = onInject => () =>
  [...document.querySelectorAll(".tweet")]
    .map(findElementToRenderDetector)
    .filter(a => a)
    .forEach(onInject);

let injectTimeout;
const injectOnFeedRefresh = onInject => {
  const observer = new MutationObserver(function(mutations) {
    clearTimeout(injectTimeout);
    injectTimeout = setTimeout(injectDetector(onInject), 100);
  });

  observer.observe(document.querySelector("#timeline"), {
    subtree: true,
    childList: true
  });
};

export default onInject => {
  if (!document.location.href.match("twitter.com")) return false;

  setInterval(injectDetector(onInject), 5000);
  injectOnFeedRefresh(onInject);
  injectDetector(onInject)();
};
