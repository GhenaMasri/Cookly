const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { email } = req.query;

  if (!email) {
    return res.status(400).send("Email parameter is required");
  }

  const userQuery = "SELECT id FROM user WHERE email = ?";
  pool.execute(userQuery, [email], async (error, userResults, fields) => {
    if (error) {
      console.error("Error executing user query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (userResults.length === 0) {
      res.status(401).send("Invalid email");
    } else {
      const userId = userResults[0].id;
      const chefQuery = "SELECT id FROM kitchen WHERE user_id = ?";
      pool.execute(chefQuery, [userId], async (err, chefResults, fields) => {
        if (err) {
          console.error("Error executing chef query:", err);
          res.status(500).send("Internal server error");
          return;
        }
        if (chefResults.length === 0) {
          res.status(401).send("User has no associated chef ID");
        } else {
          const chefId = chefResults[0].id;
          res.status(200).send({ message: "Chef ID found", chefId: chefId });
        }
      });
    }
  });
});

module.exports = router;
