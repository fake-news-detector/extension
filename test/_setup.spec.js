import fs from "fs";

global.loadFixture = path =>
  fs.readFileSync(__dirname + `/fixtures/${path}.html`);

global.userStoryFromFixture = path => {
  document.body.innerHTML = loadFixture(`facebook/${path}`);
  return document.querySelector(".fbUserStory");
};

global.tweetFromFixture = path => {
  document.body.innerHTML = loadFixture(`twitter/${path}`);
  return document.querySelector(".tweet");
};
