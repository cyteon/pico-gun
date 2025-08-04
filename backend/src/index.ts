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
            id UUID PRIMARY KEY,
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
        let { id, user, score } = query;

        if (!user || !score) {
            return "Invalid parameters";
        }

        const existing = await db.get("SELECT * FROM leaderboard WHERE id = ?", [id]);

        if (existing) {
            if (existing.score >= score) return "200 OK"; // we aint reducing your score :sob:

            await db.run("UPDATE leaderboard SET user = ?, score = ? WHERE id = ?", [user, score, id]);
            return "200 OK";
        }

        id = crypto.randomUUID();

        await db.run("INSERT INTO leaderboard (id, user, score) VALUES (?, ?, ?)", [id, user, score]);

        return `201 CREATED ${id}`;
    })
    .listen(process.env.PORT || 3000, ({ hostname, port }) => {
        console.log(`🦊 Elysia is running at ${hostname}:${port}`);
    });
