const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.delete("/", async (req, res) => {
  const { userId, deliveryId } = req.query;

  if (!userId || !deliveryId) {
    return res
      .status(400)
      .send("delivery id and user id parameters are required");
  }

  const deleteDeliveryquery = "DELETE FROM delivery WHERE id = ?";
  pool.execute(
    deleteDeliveryquery,
    [deliveryId],
    async (error, results, fields) => {
      if (error) {
        console.error("Error deleting menu item:", error);
        res.status(500).send("Internal server error");
        return;
      }
      if (results.affectedRows === 0) {
        res.status(404).send("delivery not found");
      } else {
        const deleteUserQuery = "DELETE FROM user WHERE id = ?";
        pool.execute(
          deleteUserQuery,
          [userId],
          async (error, results, fields) => {
            if (error) {
              console.error("Error deleting menu item:", error);
              res.status(500).send("Internal server error");
              return;
            }
            if (results.affectedRows === 0) {
              res.status(404).send("user not found");
            } else {
              res.status(200).send("delivery and user deleted successfully");
            }
          }
        );
      }
    }
  );
});

module.exports = router;
