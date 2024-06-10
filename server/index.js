const express = require("express");
const app = express();
const pool = require("./db");
const cors = require("cors");

const bodyParser = require("body-parser");
app.use(bodyParser.json());
app.use(cors());

//////////////////////////////////////////// CHEF ROUTES //////////////////////////////////////

const chefSignupdRoute = require("./routes/chef/chef_signup");
app.use("/chef-signup", chefSignupdRoute);

const verifyChefdRoute = require("./routes/chef/verify_chef");
app.use("/verify-chef", verifyChefdRoute);

const chefIdRoute = require("./routes/chef/get_chef_id");
app.use("/chefId", chefIdRoute);

const kitchenNameRoute = require("./routes/chef/get_kitchen_name");
app.use("/kitchenName", kitchenNameRoute);

const chefDataRoute = require("./routes/chef/get_chef_data");
app.use("/chef-data", chefDataRoute);

const editChefRoute = require("./routes/chef/edit_chef_profile");
app.use("/edit-chef", editChefRoute);

const getChefOrdersRoute = require("./routes/chef/get_orders");
app.use("/get-chef-orders", getChefOrdersRoute);

const updateOrderStatusRoute = require("./routes/chef/update_order_status");
app.use("/update-order-status", updateOrderStatusRoute);

const getChefOrderDetailsRoute = require("./routes/chef/get_order_details");
app.use("/chef-order-details", getChefOrderDetailsRoute);

const changeKitchenStatusRoute = require("./routes/chef/change_kitchen_status");
app.use("/change-kitchen-status", changeKitchenStatusRoute);

const subscribeRoute = require("./routes/chef/subscribe");
app.use("/subscribe", subscribeRoute);

const getSubscriptionDataRoute = require("./routes/chef/show_subscription");
app.use("/get-subscription", getSubscriptionDataRoute);

const checkSubscriptionRoute = require("./routes/chef/check_subscription");
app.use("/check-subscription", checkSubscriptionRoute);

//////////////////////////////////////////// GENERAL ROUTES //////////////////////////////////////

const foodCategoriesRoute = require("./routes/general/food_categories");
app.use("/food-categories", foodCategoriesRoute);

const foodQuantitiesRoute = require("./routes/general/food_quantities");
app.use("/food-quantities", foodQuantitiesRoute);

const signupRoute = require("./routes/general/signup");
app.use("/signup", signupRoute);

const signinRoute = require("./routes/general/signin");
app.use("/signin", signinRoute);

const resetPasswordRoute = require("./routes/general/reset_password");
app.use("/reset-password", resetPasswordRoute);

const kitchenCategoriesRoute = require("./routes/general/kitchen_categories");
app.use("/kitchen-categories", kitchenCategoriesRoute);

const subFoodQuantitiesRoute = require("./routes/general/sub_food_quantities");
app.use("/sub-food-quantities", subFoodQuantitiesRoute);

const saveTokenRoute = require("./routes/general/save_token");
app.use("/save-token", saveTokenRoute);

const getNotificationsRoute = require("./routes/general/get_notifications");
app.use("/get-notifications", getNotificationsRoute);

const changeNotificationStatusRoute = require("./routes/general/change_notification_status");
app.use("/change-notification-status", changeNotificationStatusRoute);

//////////////////////////////////////////// MENU ITEM ROUTES //////////////////////////////////////

const newMenuItemRoute = require("./routes/menu item/add_menu_item");
app.use("/add-menu-item", newMenuItemRoute);

const chefMenuItemsRoute = require("./routes/menu item/get_menu_items_for_chef");
app.use("/chef-menu-items", chefMenuItemsRoute);

const deleteMenuItemRoute = require("./routes/menu item/delete_menu_item");
app.use("/delete-menu-item", deleteMenuItemRoute);

const editMenuItemRoute = require("./routes/menu item/edit_menu_item");
app.use("/edit-menu-item", editMenuItemRoute);

/////////////////////////////////////////////// USER ROUTES ///////////////////////////////////////////

const userIdRoute = require("./routes/user/get_user_id");
app.use("/userId", userIdRoute);

const editUserRoute = require("./routes/user/edit_user_profile");
app.use("/edit-user", editUserRoute);

const changePasswordRoute = require("./routes/user/change_password");
app.use("/change-password", changePasswordRoute);

const kitchensByCategoriesCountRoute = require("./routes/user/kitchens_count");
app.use("/home-page", kitchensByCategoriesCountRoute);

const kitchensPerCategoryRoute = require("./routes/user/kitchens_per_category");
app.use("/kitchens", kitchensPerCategoryRoute);

const addCartItemRoute = require("./routes/user/add_cart_item");
app.use("/add-cart-item", addCartItemRoute);

const getCartItemsRoute = require("./routes/user/get_cart_items");
app.use("/get-cart-items", getCartItemsRoute);

const deleteCartItemRoute = require("./routes/user/delete_cart_item");
app.use("/delete-cart-item", deleteCartItemRoute);

const addOrderItemsRoute = require("./routes/user/add_order_items");
app.use("/add-order-items", addOrderItemsRoute);

const placeOrderRoute = require("./routes/user/place_order");
app.use("/place-order", placeOrderRoute);

const getUserOrdersRoute = require("./routes/user/get_user_orders");
app.use("/get-user-orders", getUserOrdersRoute);

const getOrderDetailsRoute = require("./routes/user/get_order_details");
app.use("/get-order-details", getOrderDetailsRoute);

const emptyCartRoute = require("./routes/user/empty_cart");
app.use("/empty-cart", emptyCartRoute);

//////////////////////////////////////////////////////////////////////////////////////////////////
const port = 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});