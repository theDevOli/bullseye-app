import { useAuth } from "../../contexts/AuthContext";
import { useEffect, useState } from "react";

import styles from "./Logout.module.css";
import Button from "../Button/Button";

import { LOGOUT_TIME } from "../../../Utils/Constants";

function Logout() {
  const { logout } = useAuth();
  const [seconds, setSeconds] = useState(LOGOUT_TIME);
  const mins = Math.floor(seconds / 60);
  const sec = seconds % 60;

  const resetTimer = () => {
    setSeconds(LOGOUT_TIME); // Reset the timer to 1200 seconds (20 minutes)
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
