const express = require('express');
const app = express();
const pool = require("./db");

const bodyParser = require('body-parser');
app.use(bodyParser.json());

//chef routes
const chefSignupdRoute = require('./routes/chef/chef_signup');
app.use('/chef-signup', chefSignupdRoute);

const verifyChefdRoute = require('./routes/chef/verify_chef');
app.use('/verify-chef', verifyChefdRoute);

const chefIdRoute = require('./routes/chef/get_chef_id');
app.use('/chefId', chefIdRoute);

const kitchenNameRoute = require('./routes/chef/get_kitchen_name');
app.use('/kitchenName', kitchenNameRoute);

const chefDataRoute = require('./routes/chef/get_chef_data');
app.use('/chef-data', chefDataRoute);

//general routes
const foodCategoriesRoute = require('./routes/general/food_categories');
app.use('/food-categories', foodCategoriesRoute);

const foodQuantitiesRoute = require('./routes/general/food_quantities');
app.use('/food-quantities', foodQuantitiesRoute);

const signupRoute = require('./routes/general/signup');
app.use('/signup', signupRoute);

const signinRoute = require('./routes/general/signin');
app.use('/signin', signinRoute);

const resetPasswordRoute = require('./routes/general/reset_password');
app.use('/reset-password', resetPasswordRoute);

const kitchenCategoriesRoute = require('./routes/general/kitchen_categories');
app.use('/kitchen-categories', kitchenCategoriesRoute);

//menu item routes
const newMenuItemRoute = require('./routes/menu item/add_menu_item');
app.use('/add-menu-item', newMenuItemRoute);

const chefMenuItemsRoute = require('./routes/menu item/get_menu_items_for_chef');
app.use('/chef-menu-items', chefMenuItemsRoute);

const deleteMenuItemRoute = require('./routes/menu item/delete_menu_item');
app.use('/delete-menu-item', deleteMenuItemRoute);

const editMenuItemRoute = require('./routes/menu item/edit_menu_item');
app.use('/edit-menu-item', editMenuItemRoute);

//user routes
const userIdRoute = require('./routes/user/get_user_id');
app.use('/userId', userIdRoute);

const editUserRoute = require('./routes/user/edit_user_profile');
app.use('/edit-user', editUserRoute);

const port = 3000;
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
