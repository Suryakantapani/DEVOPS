const express = require("express");
const mysql = require("mysql2/promise");
const cors = require("cors");
require("dotenv").config();
const app = express();
const PORT = 3000;
app.use(cors());
app.use(express.json());
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT || 3306,

    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});
async function initializeDatabase() {
    const connection = await pool.getConnection();
    try {
        await connection.query(`
            CREATE TABLE IF NOT EXISTS products (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                price DECIMAL(10,2) NOT NULL,
                stock INT NOT NULL
            )
        `);
        console.log("Products table is ready.");
    } finally {
        connection.release();
    }}
app.get("/health", (req, res) => {
    res.status(200).json({
        status: "OK"
    });
});
app.get("/api/items", async (req, res) => {
    try {
        const [rows] = await pool.query(
            "SELECT id, name, price, stock FROM products"
        );
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({
            error: "Database error"
        });
    }
});
app.post("/api/items", async (req, res) => {
    try {
        const { name, price, stock } = req.body;
        if (
            !name ||
            price === undefined ||
            stock === undefined
        ) {
            return res.status(400).json({
                error: "name, price and stock are required"
            });
}
        const [result] = await pool.query(
            `
            INSERT INTO products
            (name, price, stock)
            VALUES (?, ?, ?)
            `,
            [name, price, stock]
        );
        const [rows] = await pool.query(
            `
            SELECT id, name, price, stock
            FROM products
            WHERE id = ?
            `,
            [result.insertId]
        );
    res.status(201).json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({
            error: "Database error"
        });
    }
});
app.delete("/api/items/:id", async (req, res) => {
    const { id } = req.params;
    try {
        const [result] = await pool.execute(
            "DELETE FROM products WHERE id = ?",
            [id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({
                error: "Product not found"
            });
        }
        res.json({
            message: "Product deleted successfully",
            id: Number(id)
        });
    } catch (error) {
        console.error("Delete product error:", error);
        res.status(500).json({
            error: "Failed to delete product"
        });
}});
async function startServer() {
    try {
        await initializeDatabase();
        app.listen(PORT, () => {
            console.log(
                `NimbusCart API running on port ${PORT}`
            );
        });
    } catch (error) {
        console.error(
            "Failed to initialize application:",
            error
        );
        process.exit(1);
    }}
startServer();