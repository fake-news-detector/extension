import { StoryVotes } from "./StoryVotes.elm";
import { FlagPopup } from "./FlagPopup.elm";
import facebookInjector from "./injectors/facebook";

const popup = FlagPopup.fullscreen();

let storyVotes = {};
const onInject = (elem, url) => {
  const storyVoting = StoryVotes.embed(elem, { url: url });
  storyVoting.ports.openFlagPopup.subscribe(popup.ports.openFlagPopup.send);
  storyVotes[url] = storyVoting;
};

popup.ports.broadcastVote.subscribe(({ url, categoryId }) => {
  storyVotes[url].ports.addVote.send({ categoryId });
});

facebookInjector(onInject);
