import PropTypes from "prop-types";
import styles from "./Header.module.css";

/**
 * Header component displaying Bullseye's logo and current location.
 * @function
 * @param {Object} props - Component properties.
 * @param {string} props.children - The text content to be displayed in the header.
 * @param {string} props.type - The type of header (e.g., "loginHeader").
 * @returns {JSX.Element} - The rendered Header component.
 */
function Header({ children, type }) {
  return (
    <header>
      <div className={styles.header}>
        <img src="/public/img/logo-192.png" alt="Bullseye's Logo" />
        <h2 className={`${styles[type]}`}>
          Bullseye Inventory Management System - {children}
        </h2>
      </div>
    </header>
  );
}

/**
 * Prop types for the Header component to enforce type checking.
 * @static
 */
Header.propTypes = {
  children: PropTypes.string.isRequired,
  type: PropTypes.string,
};
export default Header;
