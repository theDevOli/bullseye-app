import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";
import { AuthProvider } from "./contexts/AuthContext.jsx";

import Admin from "./pages/Admin/Admin.jsx";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <AuthProvider>
      <App />
      {/* <Admin /> */}
    </AuthProvider>
  </React.StrictMode>
);
