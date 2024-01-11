import Button from "../../component/Button/Button";
import Header from "../../component/Header/Header";
import Footer from "../../component/Footer/Footer";

import styles from "./Help.module.css";
import { NavLink } from "react-router-dom";

/**
 * Help page for user authentication.
 * @function
 * @returns {JSX.Element} - The rendered Help page.
 */
function Help() {
  return (
    <div className={styles.help}>
      <Header type="loginHeader">Reset Password</Header>

      <div className={styles.helpBox}>
        <h1>Reset Password</h1>

        <div>
          <label htmlFor="userName">Username:</label>
          <input type="text" id="userName" />
        </div>

        <div>
          <label htmlFor="password">Password:</label>
          <input type="password" id="password" />
        </div>
        <div className={styles.btn}>
          <Button type="primary">Reset</Button>
          <Button type="back">
            <NavLink to="/" className={styles.navLink}>
              Exit
            </NavLink>
          </Button>
        </div>
      </div>
      <Footer />
    </div>
  );
}

export default Help;
