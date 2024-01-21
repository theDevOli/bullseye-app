import dotenv from "dotenv";

import helperFunctions from "../Utils/helperFunctions.js";
import Connectiondb from "../db/Conectiondb.js";
import Site from "../entity/Site.js";

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
