import dotenv from "dotenv";

import helperFunctions from "../Utils/helperFunctions.js";
import Connectiondb from "../db/Conectiondb.js";
import Position from "../entity/Position.js";

dotenv.config({ path: "../.env" });

// const host = process.env.MYSQL_HOST;
// const port = process.env.MYSQL_PORT;
// const user = process.env.MYSQL_USER;
// const password = process.env.MYSQL_PASSWORD;
// const database = process.env.MYSQL_DATABASE;
const host = "127.0.0.1";
const port = "3306";
const user = "root";
const password = "doliveira";
const database = "bullseyedb2024";

/**
 * Fetches all positions from the database.
 * @returns {Promise<Array<Position>>} An array of Position objects.
 */
async function getAllPosition() {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  let results = [];
  try {
    const [rows] = await pool.query("SELECT * FROM posn");
    rows.forEach((row) => {
      const position = new Position(row.positionID, row.permissionLevel);
      results.push(position);
    });
    return results;
  } catch (e) {
    console.error(e);
    return results;
  } finally {
    conn.closePool();
  }
}

/**
 * Retrieves a position from the database by id.
 * @param {number} id - positionID.
 * @returns {Promise<Position | null>} A Position object if found, otherwise null.
 */
async function getPositionByID(id) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [row] = await pool.query(`SELECT * FROM posn WHERE positionID = ?`, [
      id,
    ]);
    const position = new Position(row[0].positionID, row[0].permissionLevel);
    return position;
  } catch (e) {
    console.error(e);
    return null;
  } finally {
    conn.closePool();
  }
}

/**
 * Checks if an position exists in the database.
 * @param {Position} position - The position object.
 * @returns {Promise<boolean>} True if exists position, false if not found.
 */
async function positionExist(position) {
  try {
    const databasePosition = await getPositionByID(position.getPositionID());

    return databasePosition !== null;
  } catch (e) {
    console.error(e);
    return false;
  }
}

// const data = await getAllPosition();
// const data = await getPositionByID(1);
// const pos = new Position(1, "TEST");
// const data = await positionExist(pos);
// console.log(data);
