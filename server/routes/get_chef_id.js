const express = require("express");
const router = express.Router();
const pool = require("../db");

router.post("/", async (req, res) => {
  const { email } = req.body;

  const query = "SELECT id FROM user WHERE email = ?";
  pool.execute(query, [email], async (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("Invalid email");
    } else {
      const userId = results[0].id;
      const chefquery = "SELECT id FROM kitchen WHERE user_id = ?";
      pool.execute(chefquery, [userId], async (err, result, fields) => {
        if (err) {
            res.status(500).send("Internal server error");
            return;
        }
        if (result.length === 0) {
            res.status(401).send("Invalid user id");
            return;
        } else {
            const chefId = result[0].id;
            res.status(200).send({message: "chef id found", chefId: chefId});
        }
      });
    }
  });
});

module.exports = router;
