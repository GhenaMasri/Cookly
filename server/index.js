const express = require("express");
const app = express();
const pool = require("./db");
const cors = require("cors");

const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

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

const getKitchenStatusRoute = require("./routes/chef/get_kitchen_status");
app.use("/get-kitchen-status", getKitchenStatusRoute);

const getKitchenRateRoute = require("./routes/chef/get_kitchen_rate");
app.use("/get-kitchen-rate", getKitchenRateRoute);

const getAvailableDeliveryRoute = require("./routes/chef/get_available_delivery");
app.use("/get-available-delivery", getAvailableDeliveryRoute);

const assignDeliveryRoute = require("./routes/chef/assign_delivery");
app.use("/assign-delivery", assignDeliveryRoute);

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

const unreadNotificationsRoute = require("./routes/general/unread_notifications");
app.use("/unread-notifications", unreadNotificationsRoute);

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

const rateKitchenRoute = require("./routes/user/rate_kitchen");
app.use("/rate-kitchen", rateKitchenRoute);

const getPointsRoute = require("./routes/user/get_points");
app.use("/get-points", getPointsRoute);

const deletePointsRoute = require("./routes/user/delete_points");
app.use("/delete-points", deletePointsRoute);

const deleteOrderRoute = require("./routes/user/delete_order");
app.use("/delete-order", deleteOrderRoute);

/////////////////////////////////////////////// ADMIN ROUTES ///////////////////////////////////////////

const kitchensPercentageRoute = require("./routes/admin/kitchens_percentage");
app.use("/kitchens-percentage", kitchensPercentageRoute);

const usersCountRoute = require("./routes/admin/users_count");
app.use("/users-count", usersCountRoute);

const topKitchenRoute = require("./routes/admin/top_kitchen");
app.use("/top-kitchen", topKitchenRoute);

const getKitchensRoute = require("./routes/admin/get_kitchens");
app.use("/get-kitchens", getKitchensRoute);

const getDeliveryRoute = require("./routes/admin/get_delivery");
app.use("/get-delivery", getDeliveryRoute);

const deleteDeliveryRoute = require("./routes/admin/delete_delivery");
app.use("/delete-delivery", deleteDeliveryRoute);

const getKitchenDetailsRoute = require("./routes/admin/get_kitchen_details");
app.use("/get-kitchen-details", getKitchenDetailsRoute);

/////////////////////////////////////////////// DELIVERY ROUTES ///////////////////////////////////////////

const getDeliveryIdRoute = require("./routes/delivery/get_delivery_id");
app.use("/get-delivery-id", getDeliveryIdRoute);

const getDeliveryStatusRoute = require("./routes/delivery/get_delivery_status");
app.use("/get-delivery-status", getDeliveryStatusRoute);

const changeDeliveryStatusRoute = require("./routes/delivery/change_delivery_status");
app.use("/change-delivery-status", changeDeliveryStatusRoute);

const getDeliveryOrdersRoute = require("./routes/delivery/get_delivery_orders");
app.use("/get-delivery-orders", getDeliveryOrdersRoute);

const acceptDeclineOrderRoute = require("./routes/delivery/accept_decline_order");
app.use("/accept-decline-order", acceptDeclineOrderRoute);

///////////////////////////////////////////////////////////////////////////////////////////////////////////

const registrationToken = 'd4ocHlA0Q5-i-4EHbHqR4k:APA91bG1LZ6L4qG_NNoAjKMpXNepqJqSoYUV2SSDNwfnNC8GwiMW_i2C_HP9dodqLF_0_hM24317iBaW6kKds3KUgvPeV3mb09IVStph52iNiTpPBqvCvW6pnEQthmtAJYQQaFmyGyxh';

const message = {
  notification: {
    title: 'Hello!',
    body: 'You have a new message.'
  },
  token: registrationToken
};

admin.messaging().send(message)
  .then((response) => {
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });

const port = 3000;
app.listen(port, '0.0.0.0', () => {
  console.log(`Server is running on port ${port}`);
});