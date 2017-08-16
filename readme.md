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
