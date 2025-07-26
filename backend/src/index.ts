import { Elysia } from "elysia";
import { node } from "@elysiajs/node";
import { open } from "sqlite";
import sqlite3 from "sqlite3";

let db;

(async () => {
    db = await open({
        filename: "./database.db",
        driver: sqlite3.Database
    });

    await db.exec(`
        CREATE TABLE IF NOT EXISTS leaderboard (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user TEXT NOT NULL,
            score INTEGER NOT NULL
        )
    `);
})()

const app = new Elysia({ adapter: node() })
    .get("/lb/get", async ({ query }) => {
        const rows = await db.all("SELECT * FROM leaderboard ORDER BY score DESC");

        // im too lazy to deal with json in picotron so im just returning simple string
        let data = "";
        for (const row of rows) {
            data += `${row.user} ${row.score}\n`;
        }

        return data;
    })
    .get("/lb/set", async ({ query }) => {
        const { user, score } = query;

        if (!user || !score) {
            return "Invalid parameters";
        }

        await db.run("INSERT INTO leaderboard (user, score) VALUES (?, ?)", [user, score]);

        return "201 Created";
    })
    .listen(3000, ({ hostname, port }) => {
        console.log(`🦊 Elysia is running at ${hostname}:${port}`);
    });