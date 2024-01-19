import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// https://vitejs.dev/config/
export default defineConfig({
  optimizeDeps: {
    exclude: ["mock-aws-s3", "aws-sdk", "nock"],
  },
  plugins: [react()],
});
