import PropTypes from "prop-types";
import { createContext, useContext, useEffect, useReducer } from "react";

import errorMsg from "../../Utils/errorMsg";

const AuthContext = createContext();

const initialState = {
  users: [],
  currentUser: null,
  position: null,
  isLocked: false,
  attempt: 3,
  isLogin: false,
  error: null,
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
    case "getCurrentUser":
      console.log("getCurrentUser");
      const [current] = state.users.filter(
        (u) => u.username === action.payload
      );
      return { ...state, currentUser: current };
    case "invalidCredentials":
      return { ...state, attempt: state.attempt - 1 };
    case "locked":
      return { ...state, isLocked: true, error: action.payload };
    case "login":
      return {
        ...state,
        isLogin: true,
        position: state.currentUser?.position,
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
      // user,
      // password,
      currentUser,
      position,
      isLocked,
      attempt,
      isLogin,
      error,
    },
    dispatch,
  ] = useReducer(reducer, initialState);

  // function userHandler(e) {
  //   dispatch({ type: "typeUser", payload: e.target.value });
  // }

  // function passwordHandler(e) {
  //   dispatch({ type: "typePassword", payload: e.target.value });
  // }

  async function login(user, password) {
    // console.log(user, currentUser?.username);
    // dispatch({ type: "login" });
    // if (user !== currentUser?.username || currentUser?.locked) return;
    // if (isLocked) {
    //   dispatch({ type: "error", payload: errorMsg.LOCKED_ERROR });
    //   console.log(currentUser);
    //   const res = await fetch(
    //     `http://localhost:8080/EmployeeService/employees/inactive/${currentUser?.employeeID}`,
    //     { method: "PUT" }
    //   );
    //   let data = await res.json();
    //   data = data.data;
    //   console.log(data);
    console.log("before");
    dispatch({ type: "getCurrentUser", payload: user });
    console.log("after");

    if (!isLocked && attempt === 0) {
      const res = await fetch(
        `http://localhost:8080/EmployeeService/employees/inactive/${currentUser?.employeeID}`,
        { method: "PUT" }
      );
      let data = await res.json();
      data = data.data;
      console.log(data);
    }

    if (attempt === 0) {
      dispatch({ type: "locked", payload: errorMsg.LOCKED_ERROR });
      return;
    }

    // if (!currentUser) {
    //   dispatch({ type: "error", payload: errorMsg.LOGIN_ERROR });
    //   return;
    // }

    if (currentUser?.username !== user && currentUser?.password !== password) {
      dispatch({ type: "invalidCredentials" });
      return;
    }

    if (currentUser?.username === user && currentUser?.password === password) {
      dispatch({ type: "login" });
      return;
    }

    dispatch({ type: "invalidCredentials" });
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
        // user,
        // password,
        position,
        isLocked,
        attempt,
        isLogin,
        error,
        currentUser,
        // userHandler,
        // passwordHandler,
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
