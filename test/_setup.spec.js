import fs from "fs";

global.userStoryFromFixture = path => {
  document.body.innerHTML = fs.readFileSync(
    __dirname + `/fixtures/${path}.html`
  );
  return document.querySelector(".fbUserStory");
};
