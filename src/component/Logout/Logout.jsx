import { useAuth } from "../../contexts/AuthContext";
import { useEffect, useState } from "react";

import styles from "./Logout.module.css";
import Button from "../Button/Button";
// import dotenv from "dotenv";
// dotenv.config({ path: "../../.env" });
// const TIME = +process.env.LOGOUT_TIME;
const TIME = 1200;

function Logout() {
  const { logout } = useAuth();
  const [seconds, setSeconds] = useState(TIME);
  const mins = Math.floor(seconds / 60);
  const sec = seconds % 60;

  const resetTimer = () => {
    setSeconds(TIME); // Reset the timer to 1200 seconds (20 minutes)
  };

  useEffect(() => {
    const id = setInterval(() => {
      setSeconds((s) => s - 1);
    }, 1000);

    const resetTimerOnInteraction = () => {
      resetTimer();
    };

    window.addEventListener("click", resetTimerOnInteraction);
    window.addEventListener("keydown", resetTimerOnInteraction);

    return () => {
      clearInterval(id);
      window.removeEventListener("click", resetTimerOnInteraction);
      window.removeEventListener("keydown", resetTimerOnInteraction);
    };
  }, [seconds]);

  return (
    <div className={styles.logout}>
      <span>
        {mins < 10 && "0"}
        {mins}:{sec < 10 && "0"}
        {sec}
      </span>
      <Button type="logout" onClick={logout}>
        Logout
      </Button>
    </div>
  );
}

export default Logout;
