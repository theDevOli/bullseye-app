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
async function getAllItems() {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  let results = [];
  try {
    const [rows] = await pool.query(`SELECT * FROM item`);
    rows.forEach((row) => {
      const item = new Item(
        row.itemID,
        row.name,
        row.sku,
        row.description,
        row.category,
        parseFloat(row.weight),
        row.caseSize,
        parseFloat(row.costPrice),
        parseFloat(row.retailPrice),
        row.supplierID,
        row.active,
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

/**
 * Retrieves an item from the database by id.
 * @param {number} id - itemID.
 * @returns {Promise<Audit | null>} An item object if found, otherwise null.
 */
async function getItemByID(id) {
  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
    const [row] = await pool.query(`SELECT * FROM item WHERE itemID =?`, [id]);
    if (row.length === 0) return null;
    const item = new Item(
      row[0]?.itemID,
      row[0]?.name,
      row[0]?.sku,
      row[0]?.description,
      row[0]?.category,
      parseFloat(row[0]?.weight),
      row[0]?.caseSize,
      parseFloat(row[0]?.costPrice),
      parseFloat(row[0]?.retailPrice),
      row[0]?.supplierID,
      row[0]?.active,
      row[0]?.notes
    );
    return item;
  } catch (e) {
    console.error(e);
    return null;
  } finally {
    conn.closePool();
  }
}

/**
 * Checks if an item exists in the database.
 * @param {Item} item - The item object.
 * @returns {Promise<boolean>} True if exists item, false if not found.
 */
async function itemExists(item) {
  try {
    const id = item?.getItemID();
    const databaseItem = await getItemByID(id);
    return databaseItem !== null;
  } catch (e) {
    console.error(e);
    return false;
  }
}

/**
 * Adds an item to the database.
 * @param {Item} item - The item object to be added.
 * @returns {Promise<boolean>} True if the item is added successfully, false otherwise.
 */
async function addItem(item) {
  const ok = await itemExists(item);
  if (ok) return false;

  const conn = new Connectiondb(host, port, user, password, database);
  const pool = conn.getPool();
  try {
  } catch (e) {
  } finally {
    conn.closePool();
  }
}
// const data = await getAllItems();
// const data = await getItemByID(10000);
const item = new Item(
  1009,
  "Synthetic Ice",
  "60099",
  '24" x 24" piece of synthetic ice',
  "Sports Equipment",
  2.0,
  100,
  15.0,
  44.99,
  77777,
  1
);
const data = await itemExists(item);
// console.log(data);
