/**
 * @module Site
 * @extends Address
 */

import Address from "./Address";

/**
 * Creates an instance of the Site class.
 * @param {number} siteID - The unique identifier for the site.
 * @param {string} name - The name of the site.
 * @param {string} province - The province of the address.
 * @param {string} address - The street address.
 * @param {string} city - The city of the address.
 * @param {string} country - The country of the address.
 * @param {string} postalCode - The postal code of the address.
 * @param {string} phone - The phone number associated with the address.
 * @param {string} dayOfWeek - The day of the week associated with the address.
 * @param {number} distanceFromWH - The distance from a specific point (e.g., warehouse).
 * @param {string|null} notes - Additional notes related to the address.
 * @throws {Error} Throws an error if invalid data types are provided for constructor parameters.
 */
export default class Site extends Address {
  #siteID;
  #name;

  constructor(
    siteID,
    name,
    province,
    address,
    city,
    country,
    postalCode,
    phone,
    dayOfWeek,
    distanceFromWH,
    notes
  ) {
    if (typeof siteID !== "number" || typeof name !== "string") {
      throw new Error("Invalid data types for constructor parameters");
    }

    super(
      province,
      address,
      city,
      country,
      postalCode,
      phone,
      dayOfWeek,
      distanceFromWH,
      notes
    );

    this.#siteID = siteID;
    this.#name = name;
  }

  /**
   * Gets the unique identifier for the site.
   * @returns {number} The site identifier.
   */
  getSiteID() {
    return this.#siteID;
  }

  /**
   * Gets the name of the site.
   * @returns {string} The site name.
   */
  getName() {
    return this.#name;
  }

  /**
   * Converts the Site object to a JSON representation.
   * @returns {Object} The JSON representation of the site, including inherited address properties.
   */
  toJSON() {
    return {
      siteID: this.#siteID,
      name: this.#name,
      ...super.toJSON(),
    };
  }
}
