import Employee from "../back-end/entity/Employee.js";
import Audit from "../back-end/entity/Audit.js";
// import bcrypt from "bcrypt";

// const saltRounds = 10;

/**
 *Retrieves employee data in a structured format.
 * @param {Employee} employee - The employee object containing data.
 * @returns {Object} - An object containing employee data.
 */
function getEmployeeData(employee) {
  return {
    employeeID: employee.getEmployeeID(),
    username: employee.getUsername(),
    firstName: employee.getFirstName(),
    lastName: employee.getLastName(),
    email: employee.getEmail(),
    active: employee.getActive(),
    positionID: employee.getPositionID(),
    siteID: employee.getSiteID(),
    locked: employee.getLocked(),
    empPassword: employee.getPassword(),
    notes: employee.getNotes(),
  };
}

/**
 *Retrieves audit data in a structured format.
 * @param {Audit} audit - The audit object containing data.
 * @returns {Object} - An object containing audit data.
 */
function getAuditData(audit) {
  return {
    auditID: audit.getAuditID(),
    transactionID: audit.getTransactionID(),
    type: audit.getType(),
    status: audit.getStatus(),
    date: audit.getDate(),
    siteID: audit.getSiteID(),
    deliveryID: audit.getDeliveryID(),
    // employeeID:audit.getEmployeeID(),
    notes: audit.getNotes(),
  };
}
/**
 *
 * @param {*} req - The HTTP request object.
 * @returns {Employee} - An instance of the Employee class.
 */
function instantiateEmployee(req, hash) {
  const body = req.body;
  return new Employee(
    body.employeeID,
    body.username,
    body.FirstName,
    body.LastName,
    body.Email,
    body.active,
    body.PositionID,
    body.siteID,
    body.locked,
    hash,
    body.notes
  );
}

/**
 * Makes an AJAX request with the specified HTTP method.
 * @param {string} url - URL for the API
 * @param {string} method - HTTP method (GET, POST, DELETE, PUT)
 * @param {object} [data] - Data to send in the request body for POST and PUT requests
 * @returns {Promise<string>} - Data from the API
 */
export async function ajaxRequest(url, method, data = null) {
  const options = {
    method: method,
    headers: {
      "Content-Type": "application/json",
    },
    body: data ? JSON.stringify(data) : null,
  };

  const response = await fetch(url, options);
  const result = await response.text();
  return result;
}

/**
 * Creates an Employee object with invalid data, except for the id.
 *
 * @param {Object} req - The request object containing parameters.
 * @returns {Employee} - A dummy Employee object.
 */
function dummyEmployee(req) {
  const id = Number(req.params.employeeID);
  return new Employee(
    id,
    "username",
    "firstName",
    "lastName",
    "email",
    1,
    1,
    1
  );
}

// async function hashPassword(plainPassword) {
//   try {
//     const hash = await bcrypt.hash(plainPassword, saltRounds);
//     console.log("Hashed Password:", hash);
//     return hash;
//   } catch (err) {
//     console.error("Error hashing password:", err);
//   }
// }

// async function comparePasswords(enteredPassword, storedHashedPassword) {
//   try {
//     const result = await bcrypt.compare(enteredPassword, storedHashedPassword);
//     if (result) {
//       console.log("Password match!");
//     } else {
//       console.log("Password does not match!");
//     }
//     return result;
//   } catch (err) {
//     console.error("Error comparing passwords:", err);
//   }
// }

const helperFunctions = {
  getEmployeeData,
  getAuditData,
  instantiateEmployee,
  dummyEmployee,
  ajaxRequest,
  // hashPassword,
  // comparePasswords,
};

export default helperFunctions;
