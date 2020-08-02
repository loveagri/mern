# Basic MERN Stack App

### Front-End - React + Redux
### Back-End - Node.js, Express.js & MongoDB

This repo is forked from [Basic-MERN-Stack-App](https://github.com/hemakshis/Basic-MERN-Stack-App).  
All credits go to [hemakshis](https://github.com/hemakshis).

# Steps to run in PRODUCTION mode:-
1. Make sure you have yarn Node.js & MongoDB.
2. Run (from the root) `yarn install` and `cd client && yarn install`.
3. Start MongoDB service of your choice.
4. Set environment variable for the following
- `JWTSECRET` to a secret key (just make up one.) 
- `MONGODBURI` to the connecting string to your MongoDB instance. For example, 
`MONGODBURI=mongodb+srv://user:pass@cluster0-XXXX.mongodb.net/test?retryWrites=true&w=majority`

5. Build UI with `cd client && yarn build`. No need to run UI since this is only for development mode. We are aiming for deployment only.
6. Run `yarn server` to start the server. By default, it will run on port 5000. Additionally, it contains the client in `client/build` (this is why the client must be built prior to yarn server.)
The production URL is currently running at http://localhost:5000.
