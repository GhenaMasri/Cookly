const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const pool = require("../../db");

router.put("/", (req, res) => {
  const { id } = req.query;
  const { oldPassword, newPassword } = req.body;

  if (!id) {
    return res.status(400).send("Id is required");
  }

  const query = "SELECT password FROM user WHERE id = ?";

  pool.query(query, [id], (err, results) => {
    if (err) throw err;

    if (results.length === 0) {
      return res.status(404).send("User not found");
    }

    const hashedOldPassword = results[0].password;

    bcrypt.compare(oldPassword, hashedOldPassword, (err, isMatch) => {
      if (err) throw err;

      if (!isMatch) {
        return res.status(400).send("Old password is incorrect");
      }

      bcrypt.hash(newPassword, 10, (err, hashedNewPassword) => {
        if (err) throw err;

        const updateQuery = "UPDATE user SET password = ? WHERE id = ?";

        pool.query(updateQuery, [hashedNewPassword, id], (err, result) => {
          if (err) throw err;

          res.status(200).send("Password updated successfully");
        });
      });
    });
  });
});

module.exports = router;
