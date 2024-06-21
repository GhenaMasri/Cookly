const express = require("express");
const router = express.Router();
const pool = require("../../db");

router.get("/", async (req, res) => {
  const { senderId, senderType } = req.query;

  if (!senderId || !senderType) {
    return res.status(400).send("senderId, senderType parameters are required");
  }

  if (senderType === "chef") {
    // get kitchen name
    const query = "SELECT name FROM kitchen WHERE id = ?";
    pool.execute(query, [senderId], async (error, results, fields) => {
        if (error) {
          console.error("Error executing query:", error);
          res.status(500).send("Internal server error");
          return;
        }
        res.status(200).send({ senderName: results[0].name });
    });
  } else {
    // get user name
    const query = "SELECT first_name, last_name FROM user WHERE id = ?";
    pool.execute(query, [senderId], async (error, results, fields) => {
        if (error) {
          console.error("Error executing query:", error);
          res.status(500).send("Internal server error");
          return;
        }
        const name = `${results[0].first_name} ${results[0].last_name}`
        res.status(200).send({ senderName: name });
    });
  }
});

module.exports = router;
