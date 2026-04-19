# Grubify - Restaurant Management System

Grubify is a full-stack restaurant and food ordering project with:

- A Node.js + Express backend connected to Microsoft SQL Server
- A React + Vite frontend for browsing menu items and managing cart flow
- SQL scripts for schema, constraints, and restaurant data setup

## Tech Stack

- Frontend: React, Redux Toolkit, React Router, Vite, Bootstrap, Tailwind
- Backend: Node.js, Express, MSSQL, CORS
- Database: Microsoft SQL Server (stored procedures and relational schema)

## Repository Structure

```text
restaurant-management-system/
├── resturant-main/
│   ├── l230997.sql
│   └── grubify-backend/
│       ├── server.js
│       ├── db.js
│       ├── routes/
│       ├── controller/
│       └── modals/
├── resturant-website-react-main/
│   ├── package.json
│   └── src/
│       ├── App.jsx
│       ├── components/
│       ├── router/
│       └── stores/
└── README.md
```

## Backend Setup (Express + SQL Server)

### 1. Install dependencies

```bash
cd resturant-main/grubify-backend
npm install
```

### 2. Configure SQL connection

Edit `resturant-main/grubify-backend/db.js`:

```js
const dbConfig = {
  user: "sa",
  password: "12345678",
  database: "hi",
  server: "localhost\\SQLEXPRESS",
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
  options: {
    encrypt: false,
    enableArithAbort: true,
    trustServerCertificate: true,
  },
};
```

Update these values for your local SQL Server instance:

- `user`
- `password`
- `server`
- `database` (the SQL file currently creates `hi`)

### 3. Create database and tables

1. Open SQL Server Management Studio (SSMS)
2. Run `resturant-main/l230997.sql`
3. Confirm database `hi` is created with required tables

### 4. Start backend server

```bash
node server.js
```

Backend runs on: `http://localhost:3000`

## Frontend Setup (React + Vite)

### 1. Install dependencies

```bash
cd resturant-website-react-main
npm install
```

### 2. Start development server

```bash
npm run dev
```

Frontend runs on Vite default URL (usually): `http://localhost:5173`

## Key API Routes

- `POST /api/v1/login` - customer login
- `POST /api/v1/loginadmin` - admin login
- `POST /api/v1/register` - user registration
- `GET /menu/:category` - fetch products by category
- `POST /order` - create a quick order payload
- `GET /api/v2/menu` - menu endpoint from orders router

## Notes

- The project folder names use `resturant` (current naming in repository).
- Backend and frontend run as separate apps.
- Ensure SQL Server is running before starting backend.
