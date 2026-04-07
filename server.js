require("dotenv").config();
const express = require("express");
const cors = require("cors");
const path = require("path");

const app = express();

app.use(cors());
app.use(express.json({ limit: "10mb" })); // large limit for base64 images
app.use(express.urlencoded({ extended: true }));

// Serve your frontend HTML files statically
// Put all your .html files in a "public" folder next to server.js
app.use(express.static(path.join(__dirname, "public")));

// ── Routes ──────────────────────────────────────────
app.use("/products",    require("./routes/products"));
app.use("/orders",      require("./routes/orders"));
app.use("/payment",     require("./routes/payment"));
app.use("/coupons",     require("./routes/coupons"));
app.use("/contact",     require("./routes/contact"));
app.use("/newsletter",  require("./routes/newsletter"));
app.use("/admin",       require("./routes/admin"));

// ── Health check ────────────────────────────────────
app.get("/health", (req, res) => res.json({ status: "ok", time: new Date() }));

// ── Start ────────────────────────────────────────────
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`🚀 Aurora server running on http://localhost:${PORT}`));
