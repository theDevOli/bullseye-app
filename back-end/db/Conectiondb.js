import mysql from "mysql2/promise";

/**
 * Connectiondb
 */
export default class Connectiondb {
  #pool = null;

  constructor(host, port, user, password, database) {
    this.#pool = mysql.createPool({
      host: host,
      port: port,
      user: user,
      password: password,
      database: database,
    });
  }

  getPool() {
    return this.#pool;
  }

  closePool() {
    try {
      this.#pool.end();
    } catch (e) {
      console.error(e);
    }
  }
}
