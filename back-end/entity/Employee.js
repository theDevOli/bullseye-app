import { EMPLOYEE_DEFAULT_PASSWORD } from "../../Utils/Constants.js";
/**
 * @module Employee
 */
export default class Employee {
  #employeeID;
  #username;
  #firstName;
  #lastName;
  #email;
  #active;
  #positionID;
  #siteID;
  #locked;
  #password;
  #notes;

  /**
   * Creates an instance of the Employee class.
   * @param {number} employeeID - The unique identifier for the employee.
   * @param {string} username - The username associated with the employee.
   * @param {string} firstName - The first name of the employee.
   * @param {string} lastName - The last name of the employee.
   * @param {string} email - The email address of the employee.
   * @param {number} active - Indicates whether the employee is active.
   * @param {number} positionID - The unique identifier for the employee's position.
   * @param {number} siteID - The unique identifier for the employee's site.
   * @param {number} locked - Indicates whether the employee is locked(3 attempts to login).
   * @param {string} password - The password associated with the employee.
   * @param {string} notes - Additional notes or comments about the employee.
   */
  constructor(
    employeeID,
    username,
    firstName,
    lastName,
    email,
    active,
    positionID,
    siteID,
    locked,
    password = EMPLOYEE_DEFAULT_PASSWORD,
    notes = null
  ) {
    this.#employeeID = employeeID;
    this.#username = username;
    this.#firstName = firstName;
    this.#lastName = lastName;
    this.#email = email;
    this.#active = active;
    this.#positionID = positionID;
    this.#siteID = siteID;
    this.#locked = locked;
    this.#password = password;
    this.#notes = notes;
  }

  /**
   * Gets the employee's id.
   * @returns {number} The employee's id.
   */
  getEmployeeID() {
    return this.#employeeID;
  }

  /**
   * Gets the employee's username.
   * @returns {string} The employee's username.
   */
  getUsername() {
    return this.#username;
  }

  /**
   * Gets the employee's first name.
   * @returns {string} The employee's first name.
   */
  getFirstName() {
    return this.#firstName;
  }

  /**
   * Gets the employee's last name.
   * @returns {string} The employee's last name.
   */
  getLastName() {
    return this.#lastName;
  }

  /**
   * Gets the employee's email address.
   * @returns {string} The employee's email address.
   */
  getEmail() {
    return this.#email;
  }

  /**
   * Checks if the employee is active.
   * @returns {number} 1 if the employee is active, 0 otherwise.
   */
  getActive() {
    return this.#active;
  }

  /**
   * Gets the id for the employee's position.
   * @returns {number} The id for the employee's position.
   */
  getPositionID() {
    return this.#positionID;
  }

  /**
   * Gets the id for the employee's site.
   * @returns {number} The id for the employee's site.
   */
  getSiteID() {
    return this.#siteID;
  }

  /**
   * Checks if the employee is locked.
   * @returns {number} 1 if the employee is locked, 0 otherwise.
   */
  getLocked() {
    return this.#locked;
  }

  /**
   * Gets the employee's password.
   * @returns {string} The employee's password.
   */
  getPassword() {
    return this.#password;
  }

  /**
   * Gets additional notes about the employee.
   * @returns {string} Notes about the employee.
   */
  getNotes() {
    return this.#notes;
  }

  /**
   * Converts the Employee object to a JSON object.
   * @returns {Object} A JSON object representing the employee's information.
   */
  toJSON() {
    return {
      employeeID: this.#employeeID,
      username: this.#username,
      firstName: this.#firstName,
      lastName: this.#lastName,
      email: this.#email,
      active: this.#active,
      positionID: this.#positionID,
      siteID: this.#siteID,
      locked: this.#locked,
      password: this.#password,
      notes: this.#notes,
    };
  }
}
