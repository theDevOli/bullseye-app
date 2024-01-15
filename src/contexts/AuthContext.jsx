import PropTypes from "prop-types";
import { createContext, useContext, useEffect, useReducer } from "react";

import errorMsg from "../../Utils/errorMsg";

const AuthContext = createContext();

const initialState = {
  user: null,
  users: [],
  currentUser: {},
  password: "",
  position: null,
  isLocked: false,
  attempt: 3,
  isLogin: false,
  error: false,
};

/**
 * This contains all logic related to the Login
 * @param {*} state - The current state.
 * @param {*} action - The dispatched action to update the state.
 */
function reducer(state, action) {
  if (state.isLocked) return state;
  switch (action.type) {
    case "getUsers":
      return { ...state, users: action.payload };
    case "typeUser":
      return { ...state, user: action.payload };
    case "typePassword":
      return { ...state, password: action.payload };
    case "login":
      console.log(state.users);
      const [currentUser] = state.users.filter(
        (u) => u.username === state.user
      );
      const isMatch =
        currentUser?.username === state.user &&
        currentUser?.password === state.password;
      return {
        ...state,
        attempt: state.attempt - 1,
        isLogin: isMatch,
        isLocked: state.attempt <= 1 ? true : false,
        error: errorMsg.LOGIN_ERROR,
        position: isMatch ? currentUser?.positionID : null,
        currentUser: currentUser,
      };
    case "error":
      return { ...state, error: action.payload };
    case "logout":
      return { ...state, initialState };
    default:
      throw new Error("Invalid action type");
  }
}
function AuthProvider({ children }) {
  const [
    {
      user,
      password,
      currentUser,
      position,
      isLocked,
      attempt,
      isLogin,
      error,
    },
    dispatch,
  ] = useReducer(reducer, initialState);

  function userHandler(e) {
    dispatch({ type: "typeUser", payload: e.target.value });
  }

  function passwordHandler(e) {
    dispatch({ type: "typePassword", payload: e.target.value });
  }

  async function login() {
    console.log(user, currentUser?.username);
    dispatch({ type: "login" });
    if (user !== currentUser?.username || currentUser?.locked) return;
    if (isLocked) {
      dispatch({ type: "error", payload: errorMsg.LOCKED_ERROR });
      console.log(currentUser);
      const res = await fetch(
        `http://localhost:8080/EmployeeService/employees/inactive/${currentUser?.employeeID}`,
        { method: "PUT" }
      );
      let data = await res.json();
      data = data.data;
      console.log(data);
    }
  }

  function logout() {
    dispatch({ type: "logout" });
  }
  useEffect(function () {
    async function getUsers() {
      const res = await fetch(
        "http://localhost:8080/EmployeeService/employees"
      );
      let data = await res.json();
      data = data.data;
      console.log(data);
      const users = data.map((user) => {
        return {
          username: user.username,
          password: user.password,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          active: user.active,
          locked: user.locked,
          position: user.positionID,
          employeeID: user.employeeID,
        };
      });
      dispatch({ type: "getUsers", payload: users });
    }
    getUsers();
  }, []);

  return (
    <AuthContext.Provider
      value={{
        user,
        password,
        position,
        isLocked,
        attempt,
        isLogin,
        error,
        currentUser,
        userHandler,
        passwordHandler,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined)
    throw new Error("AuthContext was used outside of the AuthProvider");
  return context;
}

export { AuthProvider, useAuth };
/**
 * Prop types for the AuthProvider component to enforce type checking.
 * @static
 */
AuthProvider.propTypes = {
  children: PropTypes.element,
};
