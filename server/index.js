const express = require('express');
const app = express();

const bodyParser = require('body-parser');
app.use(bodyParser.json());

const signupRoute = require('./signup');
app.use('/signup', signupRoute);

const signinRoute = require('./signin');
app.use('/signin', signinRoute);

const port = 3000;
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
