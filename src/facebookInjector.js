// ex: https://l.facebook.com/l.php?u=https%3A%2F%2Ftecnoblog.net%2F224816%2Frumor-preco-iphone-8-plus-brasil%2F&h=ATPUoAPZS7_4ovGV7USWGOosDT_5NhE1bYLryDQKKfgt03fwcna46IbFp1CItisdDKszIIV5JfaDe9oifkpB2kdUpRQLF9AsnoXCjD9POpKrKYmrAb6cFjNtRbzZryhYOs7aygRS_bI-VUu8IfF801fPixhsajw9w7qFjSZjdjTQfUohtPKwS8Q-zor81wKNdqbWHUSLZcwCFrf8TDUELQdeHuwxJngRiWTz1d1W3dBYQqHA_Wcud__TVhpfjzAS2pBeYlbf4vXyH2HdfcQ6k0YrC2v4aBb1HWwDGw
const filterLink = a => {
  if (a.dataset.appname || a.text || !a.className) return false;

  return getNonFacebookUrl(a);
};

const getNonFacebookUrl = a => {
  if (!a.href.match(/facebook\.com/)) {
    return a.href;
  }
  const matches = a.href.match(/facebook\.com\/l.php\?u=(.*?)&/);
  if (matches) {
    return decodeURIComponent(matches[1]);
  }

  return null;
};

const injectDetector = () => {
  const storyLinks = [].filter.call(
    document.querySelectorAll(".fbUserStory a[href]"),
    filterLink
  );

  storyLinks.forEach(storyLink => {
    Elm.Main.embed(storyLink);
  });
};

let injectTimeout;
const injectOnFeedRefresh = () => {
  const observer = new MutationObserver(function(mutations) {
    clearTimeout(injectTimeout);
    injectTimeout = setTimeout(injectDetector, 100);
  });

  observer.observe(document.querySelector("[role='feed']"), {
    subtree: true,
    childList: true
  });
};
injectOnFeedRefresh();
