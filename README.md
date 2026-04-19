# Grubify

Grubify is a full-stack food ordering web application that supports role-based access for customers and admins.
It is built using React (frontend), Node.js + Express (backend), and SQL Server with stored procedures.

## Features

- Customer login and product browsing
- Admin panel to manage products
- SQL Server database with stored procedures
- Clean React UI with protected routes

## Tech Stack

- Frontend: React, Axios, React Router
- Backend: Node.js, Express
- Database: Microsoft SQL Server

## Project Structure

```text
grubify_full_stack_project/
├── backend/
│   ├── db.js                 # Configure your SQL connection here
│   ├── routes/
│   ├── controllers/
│   ├── app.js / index.js
│   └── grubify.sql           # SQL file to create database and tables
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   └── App.js
├── .gitignore
└── README.md
```

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/SheikhFareed99/grubify_full_stack_project.git
cd grubify_full_stack_project
```

### 2. Backend Setup

```bash
cd backend
npm install
```

Open `backend/db.js` and edit the database configuration:

```js
const dbConfig = {
	user: "YOUR_DB_USERNAME",
	password: "YOUR_DB_PASSWORD",
	database: "grubify",
	server: "localhost\\SQLEXPRESS", // or just "localhost"
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

Replace:

- `YOUR_DB_USERNAME` (for example: `sa`)
- `YOUR_DB_PASSWORD` (for example: `12345678`)

Example values already present in many local setups:

- `user: "sa"`
- `password: "12345678"`
- `server: "localhost\\SQLEXPRESS"`

### 3. Setup Database

1. Open SQL Server Management Studio (SSMS)
2. Run `backend/grubify.sql`
3. This creates the `grubify` database, tables, and stored procedures

### 4. Start Backend Server

```bash
node ./server.js
```

### 5. Frontend Setup

```bash
cd ../frontend
npm install
npm run dev
```

React app runs at: `http://localhost:3000`

## Demo Credentials

Customer:

- Email: `zaeem@gmail.com`
- Password: `12345`

Admin:

- Email: `admin222@example.com`
- Password: `123123`
