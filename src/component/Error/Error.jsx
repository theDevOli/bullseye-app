import styles from "./Error.module.css";
import PropTypes from "prop-types";

function Error({ children }) {
  return (
    <div className={styles.error}>
      <div className={styles.errorBox}>{children}</div>
    </div>
  );
}

/**
 * Prop types for the Error component to enforce type checking.
 * @static
 */
Error.propTypes = {
  children: PropTypes.string,
};
export default Error;
