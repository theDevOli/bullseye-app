import { NavLink } from "react-router-dom";
import Button from "../../component/Button/Button";
import Footer from "../../component/Footer/Footer";
import Header from "../../component/Header/Header";

import styles from "./Login.module.css";

/**
 * Login page for user authentication.
 * @function
 * @returns {JSX.Element} - The rendered Login page.
 */
function Login() {
  return (
    <div className={styles.login}>
      <Header type="loginHeader">Login</Header>

      <div className={styles.loginBox}>
        <h1>Login</h1>

        <div className={styles.input}>
          <label htmlFor="userName">Username:</label>
          <input type="text" id="userName" />
        </div>

        <div className={styles.input}>
          <label htmlFor="password">Password:</label>
          <input type="password" id="password" />
        </div>
        {/* <a>Forgot password?</a> */}
        <NavLink to="help">Forgot your password</NavLink>
        <Button type="primary">Login</Button>
      </div>
      <Footer />
    </div>
  );
}

export default Login;
