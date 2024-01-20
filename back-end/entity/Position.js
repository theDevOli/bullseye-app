/**
 * @module Position
 */

export default class Position {
  #positionID;
  #permissionLevel;

  /**
   * Creates an instance of Item.
   * @param {number} positionID - Unique identifier for the position.
   * @param {string} permissionLevel - The permission level of each employee.
   * @throws {Error} Throws an error if invalid data types are provided for constructor parameters.
   */
  constructor(positionID, permissionLevel) {
    if (typeof positionID !== "number" || typeof permissionLevel !== "number") {
      throw new Error("Invalid data types for constructor parameters");
    }

    this.#positionID = positionID;
    this.#permissionLevel = permissionLevel;
  }

  /**
   * Gets the position's unique identifier.
   * @returns {string} - The position's unique identifier.
   */
  getPositionID() {
    return this.#positionID;
  }

  /**
   * Gets the permission level.
   * @returns {string} - The permission level of each employee.
   */
  getPermissionLevel() {
    return this.#permissionLevel;
  }

  /**
   * Converts the Position object to a JSON object.
   * @returns {Object} A JSON object representing the Position's information.
   */
  toJSON() {
    return {
      positionID: this.#positionID,
      permissionLevel: this.#permissionLevel,
    };
  }
}
