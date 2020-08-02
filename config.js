const JWTSECRET = process.env.JWTSECRET;
const MONGODB_URI = process.env.MONGODB_URI;

module.exports = {
    jwtSecret: JWTSECRET,
    mongodburi: MONGODB_URI
};