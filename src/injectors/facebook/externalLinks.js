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

// ex: https://l.facebook.com/l.php?u=https%3A%2F%2Ftecnoblog.net%2F224816%2Frumor-preco-iphone-8-plus-brasil%2F&h=ATPUoAPZS7_4ovGV7USWGOosDT_5NhE1bYLryDQKKfgt03fwcna46IbFp1CItisdDKszIIV5JfaDe9oifkpB2kdUpRQLF9AsnoXCjD9POpKrKYmrAb6cFjNtRbzZryhYOs7aygRS_bI-VUu8IfF801fPixhsajw9w7qFjSZjdjTQfUohtPKwS8Q-zor81wKNdqbWHUSLZcwCFrf8TDUELQdeHuwxJngRiWTz1d1W3dBYQqHA_Wcud__TVhpfjzAS2pBeYlbf4vXyH2HdfcQ6k0YrC2v4aBb1HWwDGw
const isExternalLink = a => {
  if (a.dataset.appname || a.text || !a.className) return false;

  return getExternalUrl(a);
};

const getExternalUrl = a => {
  if (!a.href.match(/facebook\.com/)) {
    return a.href;
  }
  const matches = a.href.match(/facebook\.com\/l.php\?u=(.*?)&/);
  if (matches) {
    return decodeURIComponent(matches[1]);
  }

  return null;
};

const getStoryTitle = a => a.parentNode.querySelector("a").textContent;
