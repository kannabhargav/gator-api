"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require('express');
const cors = require('cors');
const app = express();
const authRoutes = require('./auth-routes');
const serviceRoutes = require('./service-routes');
const passport_setup = require('./passport-setup');
const cookieSession = require('cookie-session');
const keys_1 = require("./keys");
const passport = require('passport');
const session = require('express-session');
app.set('view engine', 'ejs');
app.use(cors());
app.use(function (req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET, POST');
    res.header('Access-Control-Max-Age', '10');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
});
// app.use (cookieSession ({
//   keys:keys.github.session.cookieKey,
//   maxAge: 24*60*60*1000
// }));
app.use(cookieSession({
    key: 'git-user',
    secret: keys_1.keys.github.session.cookieKey,
    cookie: {
        maxAge: 24 * 60 * 60 * 1000,
        secure: false,
    },
    httpOnly: false,
}));
app.use(session({ secret: 'cats' }));
//initialize passport
app.use(passport.initialize());
app.use(passport.session());
app.use('/auth', authRoutes);
app.use('/service', serviceRoutes);
app.get('/', (req, res) => {
    res.render('home');
});
app.get('/success', (req, res) => {
    res.render('success');
});
const port = process.env.PORT || 3000;
app.listen(port, () => {
    console.log('listenting for request on port 3000');
});
//# sourceMappingURL=app.js.map