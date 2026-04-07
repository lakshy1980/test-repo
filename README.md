# Aurora Backend — Setup Guide

## Folder Structure

```
aurora-backend/
├── server.js              ← main entry point
├── db.js                  ← MySQL connection
├── .env                   ← your secrets (never share this)
├── package.json
├── public/                ← PUT ALL YOUR .html FILES HERE
│   ├── index.html
│   ├── search.html
│   ├── product.html
│   ├── payment.html
│   ├── about.html
│   └── contact.html
└── routes/
    ├── products.js
    ├── orders.js
    ├── payment.js
    ├── coupons.js
    ├── contact.js
    ├── newsletter.js
    └── admin.js
```

---

## Step 1 — Install Node.js
Download from https://nodejs.org and install the LTS version.

## Step 2 — Install MySQL
Download MySQL Community Server from https://dev.mysql.com/downloads/
During setup, set a root password and remember it.

## Step 3 — Create the database
Open MySQL command line and run:
```
mysql -u root -p < schema.sql
```
This creates all your tables and sample products.

## Step 4 — Configure .env
Open the `.env` file and fill in:
- `DB_PASSWORD` → your MySQL root password
- `ADMIN_PASSWORD` → choose any password for your admin panel
- `ADMIN_TOKEN` → choose any random secret string (like `aurora_secret_xyz123`)

## Step 5 — Install packages
Open a terminal in the `aurora-backend` folder and run:
```
npm install
```

## Step 6 — Start the server
```
npm start
```
You should see:
```
✅ MySQL connected
🚀 Aurora server running on http://localhost:5000
```

## Step 7 — Move your HTML files
Copy all your `.html` files into the `public/` folder inside `aurora-backend/`.
Now visit http://localhost:5000 in your browser — your site loads!

---

## API Reference

### Products
| Method | URL | Description |
|--------|-----|-------------|
| GET | /products | Get all products |
| GET | /products?category=hoodies | Filter by category |
| GET | /products?search=blue | Search products |
| GET | /products/:id | Get one product |
| GET | /products/:id/reviews | Get reviews |
| POST | /products/:id/reviews | Add a review |

### Orders
| Method | URL | Description |
|--------|-----|-------------|
| POST | /orders | Place an order |
| GET | /orders/:order_id | Track your order |

### Payment (UPI)
| Method | URL | Description |
|--------|-----|-------------|
| GET | /payment/qr | Get UPI QR image |
| POST | /payment/submit-txn | Submit transaction ID |
| PUT | /payment/verify/:order_id | Admin: verify/reject |
| GET | /payment/pending | Admin: pending verifications |
| POST | /payment/qr | Admin: upload QR image |

### Coupons
| Method | URL | Description |
|--------|-----|-------------|
| POST | /coupons/validate | Validate a coupon code |

### Contact & Newsletter
| Method | URL | Description |
|--------|-----|-------------|
| POST | /contact | Submit contact form |
| POST | /newsletter | Subscribe to newsletter |

### Admin
| Method | URL | Description |
|--------|-----|-------------|
| POST | /admin/login | Login (returns token) |
| GET | /admin/stats | Dashboard overview |
| GET | /admin/orders | All orders |

---

## How Payment Works (UPI QR)

1. You upload your UPI QR image via the admin panel (base64)
2. Customer adds items to cart and goes to checkout
3. The payment page fetches and shows your QR code
4. Customer pays via PhonePe / GPay / any UPI app
5. Customer enters their UTR/Transaction ID on the payment page
6. You (admin) get notified and verify in the admin panel
7. Order status changes to "verified" and is confirmed

---

## Admin Panel

Send this header with all admin requests:
```
x-admin-token: YOUR_ADMIN_TOKEN_FROM_ENV
```

Or use the login endpoint:
```
POST /admin/login
{ "password": "your_admin_password" }
→ returns { "token": "..." }
```

---

## Update Your HTML Files

Change the API URL in your HTML files from `localhost:5000` to match your server.
In `search.html`, find: `const API = 'http://localhost:5000';`
This is correct for local development. When you deploy online, change it to your server URL.
