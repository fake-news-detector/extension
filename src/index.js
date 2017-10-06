import { StoryVotes } from "./StoryVotes.elm";
import { FlagPopup } from "./FlagPopup.elm";
import facebookInjector from "./injectors/facebook";
import uuidv4 from "uuid/v4";

const uuid = localStorage.getItem("uuid") || uuidv4();
localStorage.setItem("uuid", uuid);

const popup = FlagPopup.fullscreen({ uuid });

let storyVotes = {};
const onInject = (elem, url, title) => {
  console.log("title", title);
  const storyVoting = StoryVotes.embed(elem, { url, title });
  storyVoting.ports.openFlagPopup.subscribe(popup.ports.openFlagPopup.send);
  storyVotes[url] = storyVoting;
};

popup.ports.broadcastVote.subscribe(({ url, categoryId }) => {
  storyVotes[url].ports.addVote.send({ categoryId });
});

facebookInjector(onInject);
