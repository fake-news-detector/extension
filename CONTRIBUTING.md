----

[Pre-Requirements](#pre-requirements) | [Running](#running) | [Testing](#testing) | [Debugging](#debugging) | [Formatting](#formatting)

----

Contributing
=======

Contributions are always welcome, no matter how large or small.

## Pre-Requirements

You need to have installed:

- [nodejs](https://nodejs.org/en/download/)
- npm 5+ (run `npm -g install npm`)
- elm (run `npm -g install elm`)
- [Firefox Quantum](https://www.mozilla.org/en-US/firefox/quantum/)

If you don't know elm, don't worry, you can contribute without it, but if you want to know more, the best place to start is the [official guide](https://guide.elm-lang.org/).

## Running

First install the dependencies

```
npm install
```

This will download both javascript and elm dependencies. Now, start the project:

```
npm start
```

It should fire up firefox for you, now go to `facebook.com` or `twitter.com`, sign in and scroll to see it working on some news.

## Testing

To run the tests, you can execute:

```
npm test
```

If you want it in watch mode, you can run `npm run test:watch`

The JavaScript code is more important to test because it is much more fragile.

Since it is the JavaScript that injects the extension on twitter and facebook, any changes on their layout might break the extension.

For testing that, we use fixtures, which are a snapshot from the original html snippets where the extension will plug into, they live at `test/fixtures`.

## Debugging

If the extension throws an exception or if you add any `console.log`, it won't show on the regular browser console, neither the network requests.

Instead, for debugging it on firefox you will need to open Tools > Web Developer > Browser Toolbox

![Tools > Web Developer > Browser Toolbox](https://user-images.githubusercontent.com/792201/31666402-d81136dc-b32a-11e7-885c-4daa770d67bd.png)

This console shows the logs from *everything* on the browser, which can be too much noisy, to focus on developing the extension, you can type `bundle.js` on the search field on the top left corner.

![Filtering bundle.js](https://user-images.githubusercontent.com/792201/31666481-285ab38e-b32b-11e7-89a1-788ac5bfeb68.png)

## Formatting

For automatically format the source code, we use two opinionated tools:

- [elm-format](https://github.com/avh4/elm-format) for Elm code
- [Prettier](https://prettier.io/) for JavaScript code

They both have good integrations with almost every code editor, you should install them on your editor because they format the code automatically, keeping a standard across the codebase.

Also, we add no configuration to them, just install the plugins and use the standard behaviours, this way we eliminate the discussions about formatting on PRs.
