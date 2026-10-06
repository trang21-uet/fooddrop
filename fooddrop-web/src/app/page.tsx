import { redirect } from "next/navigation";

// Middleware sends signed-out visitors to /login; everyone else lands on their recipes.
export default function Home() {
  redirect("/recipes");
}
