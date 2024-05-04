const express = require("express");
const router = express.Router();
const jwt = require("jsonwebtoken");
const nodemailer = require("nodemailer");
const pool = require("./db");

router.post("/", (req, res) => {
  const { email } = req.body;

  const query = "SELECT * FROM user WHERE email = ?";
  pool.execute(query, [email], (error, results, fields) => {
    if (error) {
      console.error("Error executing query:", error);
      res.status(500).send("Internal server error");
      return;
    }
    if (results.length === 0) {
      res.status(401).send("This email not exist!");
    } else {
      const user = results[0];
      const token = jwt.sign({ email: user.email }, "cookly-reset-password", {
        expiresIn: "1h",
      });
      const resetLink = `http://192.168.1.106:3000/reset-password?token=${token}`;
      sendResetEmail(user.email, resetLink);
      res.status(200).send("Password reset email sent successfully");
    }
  });
});

function sendResetEmail(email, resetLink) {
  const transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    service: "gmail",
    auth: {
      user: "cooklyapplication@gmail.com",
      pass: "cookly321",
    },
  });

  const mailOptions = {
    from: "cookly@gmail.com",
    to: email,
    subject: "Password Reset",
    html: `<p>You have requested to reset your password. Click <a href="${resetLink}">here</a> to reset your password.</p>`,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.error("Error sending email:", error);
    } else {
      console.log("Email sent:", info.response);
    }
  });
}

module.exports = router;
