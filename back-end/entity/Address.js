/**
 * @module Address
 */

export default class Address {
  #province;
  #address;
  #city;
  #country;
  #postalCode;
  #phone;
  #dayOfWeek;
  #distanceFromWH;
  #notes;

  /**
   * Creates an instance of the Address class.
   * @param {string} province - The province of the address.
   * @param {string} address - The street address.
   * @param {string} city - The city of the address.
   * @param {string} country - The country of the address.
   * @param {string} postalCode - The postal code of the address.
   * @param {string} phone - The phone number associated with the address.
   * @param {string} dayOfWeek - The day of the week associated with the address.
   * @param {number} distanceFromWH - The distance from a specific point (e.g., warehouse).
   * @param {string|null} notes - Additional notes related to the address.
   * @throws {Error} Throws an error if invalid data types are provided.
   */
  constructor(
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
    if (
      typeof province !== "string" ||
      typeof address !== "string" ||
      typeof city !== "string" ||
      typeof country !== "string" ||
      typeof postalCode !== "string" ||
      typeof phone !== "string" ||
      typeof dayOfWeek !== "string" ||
      typeof distanceFromWH !== "number"
    ) {
      throw new Error("Invalid data types for constructor parameters");
    }

    this.#province = province;
    this.#address = address;
    this.#city = city;
    this.#country = country;
    this.#postalCode = postalCode;
    this.#phone = phone;
    this.#dayOfWeek = dayOfWeek;
    this.#distanceFromWH = distanceFromWH;
    this.#notes = notes = null;
  }

  /**
   * Gets the province of the address.
   * @returns {string} The province.
   */
  getProvince() {
    return this.#province;
  }

  /**
   * Gets the street address.
   * @returns {string} The address.
   */
  getAddress() {
    return this.#address;
  }

  /**
   * Gets the city of the address.
   * @returns {string} The city.
   */
  getCity() {
    return this.#city;
  }

  /**
   * Gets the country of the address.
   * @returns {string} The country.
   */
  getCountry() {
    return this.#country;
  }

  /**
   * Gets the postal code of the address.
   * @returns {string} The postal code.
   */
  getPostalCode() {
    return this.#postalCode;
  }

  /**
   * Gets the phone number associated with the address.
   * @returns {string} The phone number.
   */
  getPhone() {
    return this.#phone;
  }

  /**
   * Gets the day of the week associated with the address.
   * @returns {string} The day of the week.
   */
  getDayOfWeek() {
    return this.#dayOfWeek;
  }

  /**
   * Gets the distance from a specific point (e.g., warehouse).
   * @returns {number} The distance.
   */
  getDistanceFromWH() {
    return this.#distanceFromWH;
  }

  /**
   * Gets additional notes related to the address.
   * @returns {string|null} The notes.
   */
  getNotes() {
    return this.#notes;
  }

  /**
   * Converts the Address object to a JSON representation.
   * @returns {Object} The JSON representation of the address.
   */
  toJSON() {
    return {
      province: this.#province,
      address: this.#address,
      city: this.#city,
      country: this.#country,
      postalCode: this.#postalCode,
      phone: this.#phone,
      dayOfWeek: this.#dayOfWeek,
      distanceFromWH: this.#distanceFromWH,
      notes: this.#notes,
    };
  }
}
