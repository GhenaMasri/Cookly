const express = require('express');
const app = express();
const pool = require("./db");

const bodyParser = require('body-parser');
app.use(bodyParser.json());

const signupRoute = require('./routes/signup');
app.use('/signup', signupRoute);

const signinRoute = require('./routes/signin');
app.use('/signin', signinRoute);

const resetPasswordRoute = require('./routes/reset_password');
app.use('/reset-password', resetPasswordRoute);

const verifyChefdRoute = require('./routes/verify_chef');
app.use('/verify-chef', verifyChefdRoute);

const chefSignupdRoute = require('./routes/chef_signup');
app.use('/chef-signup', chefSignupdRoute);

const kitchenCategoriesRoute = require('./routes/kitchen_categories');
app.use('/kitchen-categories', kitchenCategoriesRoute);

const chefIdRoute = require('./routes/get_chef_id');
app.use('/chefId', chefIdRoute);

const userIdRoute = require('./routes/get_user_id');
app.use('/userId', userIdRoute);

const kitchenNameRoute = require('./routes/get_kitchen_name');
app.use('/kitchenName', kitchenNameRoute);

const newMenuItemRoute = require('./routes/menu_item');
app.use('/add-menu-item', newMenuItemRoute);

const foodCategoriesRoute = require('./routes/food_categories');
app.use('/food-categories', foodCategoriesRoute);

const foodQuantitiesRoute = require('./routes/food_quantities');
app.use('/food-quantities', foodQuantitiesRoute);

const port = 3000;
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
