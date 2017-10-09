export const getExternalLinkStory = userStory => {
  const link = [...userStory.querySelectorAll("a[href]")].filter(
    isExternalLink
  )[0];

  if (!link) return null;

  return {
    elem: link,
    title: getStoryTitle(link),
    url: getExternalUrl(link)
  };
};

const isExternalLink = a => {
  if (a.dataset.appname || a.text || !a.className) return false;

  return getExternalUrl(a);
};

export const getExternalUrl = a => {
  if (!a.href.match(/facebook\.com/) && a.href.match(/http/)) {
    return a.href;
  }
  const matches = a.href.match(/facebook\.com\/l.php\?u=(.*?)&/);
  if (matches) {
    return decodeURIComponent(matches[1]);
  }

  return null;
};

const getStoryTitle = a => a.parentNode.querySelector("a").textContent;
