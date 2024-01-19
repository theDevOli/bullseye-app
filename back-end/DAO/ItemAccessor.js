import dotenv from "dotenv";

import helperFunctions from "../Utils/helperFunctions.js";
import Connectiondb from "../db/Conectiondb.js";
import Item from "../entity/Item.js";

dotenv.config({ path: "../.env" });

const host = process.env.MYSQL_HOST;
const port = process.env.MYSQL_PORT;
const user = process.env.MYSQL_USER;
const password = process.env.MYSQL_PASSWORD;
const database = process.env.MYSQL_DATABASE;

/**
 * Fetches all audit entries from the database.
 * @returns {Promise<Array<Audit>>} An array of Audit objects representing all audit entries.
 */
export async function getAllItems() {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  let results = [];
  try {
    const [rows] = await pool.query(`SELECT * FROM item`);
    console.log(rows);
    rows.forEach((row) => {
      const item = new Item(
        row.itemID,
        row.name,
        row.description,
        row.category,
        row.weight,
        row.caseSize,
        row.deliveryID,
        row.siteID,
        row.notes
      );
      results.push(item);
    });
    return results;
  } catch (e) {
    console.error(e);
    return results;
  } finally {
    conn.closePool();
  }
}
await getAllItems();
