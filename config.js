// const JWTSECRET = process.env.JWTSECRET;
// const MONGODB_URI = process.env.MONGODB_URI;
//
// module.exports = {
//     jwtSecret: JWTSECRET,
//     mongodburi: MONGODB_URI
// };


const JWTSECRET = process.env.JWTSECRET;
const DB_USERNAME = process.env.DB_USERNAME;
const DB_PASSWORD = process.env.DB_PASSWORD;
const DB_NAME = process.env.DB_NAME;

module.exports = {
    jwtSecret: JWTSECRET,
    mongodburi: 'mongodb+srv://' + DB_USERNAME + ':' + DB_PASSWORD + '@cluster0.sgccc.gcp.mongodb.net/' + DB_NAME + '?retryWrites=true&w=majority'
};