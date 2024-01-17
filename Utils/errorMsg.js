/**
 * @module errorMsg
 * @description This contains all error messages that will be displayed to the user.
 */

/**
 *Server error message
 *@type {string}
 *@constant
 *@description Message: "Internal Server Error.  Please contact the network administrator"
 */
const SERVER_ERROR =
  "Internal Server Error: Please contact the network administrator.";

/**
 *Conflict error message
 *@type {string}
 *@constant
 *@description Message: "Conflict: The resource you are trying to create/update already exists or does not exist. Please provide unique data or check the existing resource.
"
 */
const CONFLICT_ADD_ERROR =
  "Conflict: The resource you are trying to create already exists. Please check your data or use a different set of information.";

/**
 *Bad request error message
 *@type {string}
 *@constant
 *@description Message: "Bad Request: The request could not be understood or was missing required parameters."
 */
const BAD_REQUEST_ERROR =
  "Bad Request: The request could not be understood or was missing required parameters.";

/**
 *Not found error message
 *@type {string}
 *@constant
 *@description Message: "Not found: The request could not be found."
 */
const NOT_FOUND_ERROR = "Not found: The request could not be found.";

/**
 *Unsupported bulk operation error message
 *@type {string}
 *@constant
 *@description Message: "Not supported operation: Bulk operations are not supported."
 */
const BULK_ERROR =
  "Not supported operation: Bulk operations are not supported.";

/**
 *Unsupported single operation error message
 *@type {string}
 *@constant
 *@description Message: "Internal Server Error.  Please contact the network administrator."
 */
const SINGLE_ERROR =
  "Not supported operation: Single operations are not supported.";

/**
 *Login error message
 *@type {string}
 *@constant
 *@description Message: "Invalid Credentials: Invalid username and/or password. Please contact your Administrator admin@bullseye.ca for assistance."
 */
const LOGIN_ERROR =
  "Invalid Credentials: Invalid username and/or password. Please contact your Administrator admin@bullseye.ca for assistance.";

/**
 *Locked login error message
 *@type {string}
 *@constant
 *@description Message: "Invalid Credentials: invalid username and/or password. Please contact your Administrator admin@bullseye.ca for assistance."
 */
const LOCKED_ERROR =
  "Locked Account: Your account has been locked because of too many incorrect login attempts. Please contact your Administrator at admin@bullseye.ca for assistance.";

/**
 *Missing output error message
 *@type {string}
 *@constant
 *@description Message: "All fields are required: Please fill up all inputs."
 */
const MISSING_OUTPUT_ERROR =
  "All fields are required: Please fill up all inputs.";

/**
 *Not matched error message
 *@type {string}
 *@constant
 *@description Message: "Fields does not match: The new password field must be equal to confirm password field."
 */
const NOT_MATCHED_ERROR =
  "Fields does not match: The new password field must be equal to confirm password field.";

/**
 *Minimum length error message
 *@type {string}
 *@constant
 *@description Message: "Password rules: At least one latter must be uppercase."
 */
const MIN_LEN_ERROR = "Password rules: At least 8 characters long.";

/**
 *Uppercase error message
 *@type {string}
 *@constant
 *@description Message: "Password rules: At least one letter must be uppercase."
 */
const UPPERCASE_ERROR =
  "Password rules: At least one letter must be uppercase.";

/**
 *Uppercase error message
 *@type {string}
 *@constant
 *@description Message: "Password rules: At least one latter must be uppercase."
 */
const SPECIAL_ERROR =
  "Password rules: At least one letter must be a special character.";

// /**
//  *Not found user login error message
//  *@type {string}
//  *@constant
//  *@description Message: "Invalid Credentials: invalid username and/or password. Please contact your Administrator admin@bullseye.ca for assistance."
//  */
// const NOT_FOUD_USER_ERROR =
//   "Locked Account: Your account has been locked because of too many incorrect login attempts. Please contact your Administrator at admin@bullseye.ca for assistance.";

/**
 * Object that encapsulates all error messages provided by the module.
 * @type {object}
 * @exports errorMsg
 */
const errorMsg = {
  SERVER_ERROR,
  CONFLICT_ADD_ERROR,
  BAD_REQUEST_ERROR,
  NOT_FOUND_ERROR,
  BULK_ERROR,
  SINGLE_ERROR,
  LOGIN_ERROR,
  LOCKED_ERROR,
  MISSING_OUTPUT_ERROR,
  NOT_MATCHED_ERROR,
  MIN_LEN_ERROR,
  UPPERCASE_ERROR,
  SPECIAL_ERROR,
};

export default errorMsg;
