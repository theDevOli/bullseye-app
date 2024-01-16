import PropTypes from "prop-types";
import styles from "./Header.module.css";
import Logout from "../Logout/Logout";
import UserInfo from "../UserInfo/UserInfo";

/**
 * Header component displaying Bullseye's logo and current location.
 * @function
 * @param {Object} props - Component properties.
 * @param {string} props.children - The text content to be displayed in the header.
 * @param {string} props.type - The type of header (e.g., "loginHeader").
 * @returns {JSX.Element} - The rendered Header component.
 */
function Header({ children, type }) {
  const isLogin = true;
  return (
    <header>
      <div className={`${styles[type]}`}>
        <img src="/img/logo-192.png" alt="Bullseye's Logo" />
        <div>
          <h2 className={`${styles[type]}`}>
            Bullseye Inventory Management System - {children}
          </h2>
          {isLogin && <UserInfo />}
        </div>
        {isLogin && <Logout />}
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
