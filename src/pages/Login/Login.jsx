import { NavLink } from "react-router-dom";

import Button from "../../component/Button/Button";
import Footer from "../../component/Footer/Footer";
import Header from "../../component/Header/Header";

import styles from "./Login.module.css";
import { useAuth } from "../../contexts/AuthContext";
import { useState } from "react";

/**
 * Login page for user authentication.
 * @function
 * @returns {JSX.Element} - The rendered Login page.
 */
function Login() {
  const {
    position,
    isLocked,
    attempt,
    isLogin,
    error,
    // userHandler,
    // passwordHandler,
    login,
    logout,
  } = useAuth();
  const [user, setUser] = useState("econcepcion");
  const [password, setPassword] = useState("P@ssw0rd-");

  function userHandler(e) {
    setUser(e.target.value);
  }

  function passwordHandler(e) {
    setPassword(e.target.value);
  }

  return (
    <div className={styles.login}>
      <Header type="loginHeader">Login</Header>

      <div className={styles.loginBox}>
        <h1>Login</h1>

        <div className={styles.input}>
          <label htmlFor="userName">Username:</label>
          <input
            type="text"
            id="userName"
            disabled={isLocked}
            onChange={(e) => userHandler(e)}
          />
        </div>

        <div className={styles.input}>
          <label htmlFor="password">Password:</label>
          <input
            type="password"
            id="password"
            disabled={isLocked}
            onChange={(e) => passwordHandler(e)}
          />
        </div>
        {/* <a>Forgot password?</a> */}
        <NavLink to="help">Forgot your password</NavLink>
        <Button
          disabled={isLocked}
          type="primary"
          onClick={() => login(user, password)}
        >
          Login
        </Button>
      </div>
      <Footer />
    </div>
  );
}

export default Login;
