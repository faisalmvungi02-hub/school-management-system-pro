import { redirect } from "next/navigation";

export default function PlatformAdministrationRoot() {
  redirect("/platform/login");
}
