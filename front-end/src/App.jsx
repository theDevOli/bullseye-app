import { BrowserRouter, Routes, Route } from "react-router-dom";

import Login from "./pages/Login/Login";
import Admin from "./pages/Admin/Admin";
import Financial from "./pages/Financial/Financial";
import WarehouseWorker from "./pages/Warehouse/WarehouseWorker";
import WarehouseManager from "./pages/Warehouse/WarehouseManager";
import StoreManager from "./pages/Store/StoreManager";
import StoreWorker from "./pages/Store/StoreWorker";
import Help from "./pages/Help/Help";

// import helperFunctions from "../Utils/helperFunctions";

/**
 * Main App component responsible for rendering GUI routes.
 * @function
 * @returns {JSX.Element} - The rendered GUI routes.
 */
function App() {
  return (
    <>
      <BrowserRouter>
        <Routes>
          <Route index element={<Login />} />
          <Route path="admin" element={<Admin />} />
          <Route path="finance" element={<Financial />} />
          <Route path="warehouseWorker" element={<WarehouseWorker />} />
          <Route path="warehouseManager" element={<WarehouseManager />} />
          <Route path="storeManager" element={<StoreManager />} />
          <Route path="storeWorker" element={<StoreWorker />} />
          <Route path="help" element={<Help />} />
        </Routes>
      </BrowserRouter>
    </>
  );
}

export default App;
