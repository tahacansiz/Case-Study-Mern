import React, { useEffect, useState } from "react";
import { API_BASE_URL } from "../config.js";

export default function HealthStatus() {
  const [status, setStatus] = useState([]);

  useEffect(() => {
    fetch(`${API_BASE_URL}/healthcheck/`)
      .then((response) => response.json())
      .then((data) => setStatus(data));
  }, []);

  return (
    <div>
      <h3>deisşdfsss</h3>
      {JSON.stringify(status)}
    </div>
  );
}
