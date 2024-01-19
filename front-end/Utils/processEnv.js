/**
 * @module processEnv
 *@description Configures the .env file, and exports MySQL connection parameters.
 */

import dotenv from "dotenv";

dotenv.config({ path: "../.env" });

/**
 * MySQL host address
 * @type {string}
 * @exports host
 */
export const host = process.env.MYSQL_HOST;

/**
 * MySQL port number
 * @type {string}
 * @exports port
 */
export const port = process.env.MYSQL_PORT;

/**
 * MySQL username for database connection
 * @type {string}
 * @exports user
 */
export const user = process.env.MYSQL_USER;

/**
 * MySQL password for database connection
 * @type {string}
 * @exports password
 */
export const password = process.env.MYSQL_PASSWORD;

/**
 * MySQL database name
 * @type {string}
 * @exports database
 */
export const database = process.env.MYSQL_DATABASE;

console.log(host, port, user, password, database);
