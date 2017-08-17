# About
Hey, I'm Oz. I build my own digital art tools and then stream myself using them. These are those tools and streamer.

-------------------------------------------------------------

# Installing Locally

## Prereqs
- Install node: https://nodejs.org/en/
- Install yarn: `npm install --global yarn`
- Install gulp: `yarn install --global gulp-cli`
- Install slim: `gem install slim`

## Setup environment
- Install environment: `yarn install`
- Run file watchers: `gulp`
- From command line root, run `firebase login; firebase init`, select your install and select database/hosting
- Create an `/assets/slim/firebase.slim` with appropriate call `firebase.initializeApp(config)`
  - Add a line `_MAIN_ARTIST_UUID = 'YOUR_FIREBASE_UUID'` to set the main sites person

## Whitelabel
- Open `/assets/slim/index.slim` and make it yours

-------------------------------------------------------------

# Creating tools

Use the `app.addTool(id, config)` method to create new tools. `id` is a _string_ representing the tool (which can later be retreived with `app.getTool(id)`). `config` is an **object** defining the tool. `app.addTool` adds the following automatically to `config`, which you can overwrite:

```coffee
# Whether to make this tool the default (true) or not (false)
# - Default tools
default: false

# List of keyboard shortcuts, where shortcut is any valid keyboard shortcut string (see https://craig.is/killing/mice). Method is a STRING or FUNCTION. If it's a string then it's interpreted as a method name on the tool class, otherwise the method itself is called.
shortcuts:
  'shortcut': method
```

-------------------------------------------------------------

# Data Stores

For now, all data is stored in localStorage. To create a store, use the `app.addStore(id, config)` method, which you can later retrieve with `app.getStore(id)`. All stores are autoloaded on page load.
