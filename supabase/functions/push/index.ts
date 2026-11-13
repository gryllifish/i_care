// Sends the news the database hands over (migrations/*_push_notifications
// .sql) through Firebase Cloud Messaging. The database already decided who
// is told; this only checks the caller and delivers.
//
// Secrets (`supabase secrets set`):
//   PUSH_HOOK_SECRET     the same value as Vault's `push_hook_secret`
//   FCM_SERVICE_ACCOUNT  the Firebase service account JSON
//
// Messages say only what kind of news there is: no names, medications or
// other health data travel through Google's or Apple's servers.

type Kind =
  | "note"
  | "appointment"
  | "medication"
  | "double_dose"
  | "access";
type Target = { token: string; platform: string; language: "en" | "es" };
type ServiceAccount = {
  project_id: string;
  client_email: string;
  private_key: string;
};

const texts: Record<Kind, Record<Target["language"], string>> = {
  note: {
    en: "There is a new note for the circle.",
    es: "Hay una nota nueva para el círculo.",
  },
  appointment: {
    en: "An appointment was added or changed.",
    es: "Se agregó o cambió un turno.",
  },
  medication: {
    en: "A medication was added, changed or stopped.",
    es: "Se agregó, cambió o suspendió un medicamento.",
  },
  double_dose: {
    en: "A dose was recorded twice. Please check it.",
    es: "Se registró dos veces una toma. Revisala.",
  },
  access: {
    en: "Someone in the circle is using a new phone. Check it was them.",
    es: "Alguien del círculo está usando un teléfono nuevo. Revisá que haya sido esa persona.",
  },
};

Deno.serve(async (request) => {
  const secret = Deno.env.get("PUSH_HOOK_SECRET");
  const account = Deno.env.get("FCM_SERVICE_ACCOUNT");
  if (!secret || !account) {
    return new Response("Not configured", { status: 503 });
  }
  if (
    request.method !== "POST" ||
    !sameText(request.headers.get("x-icare-hook-secret") ?? "", secret)
  ) {
    return new Response("Forbidden", { status: 403 });
  }

  const body = await request.json().catch(() => null);
  const kind = body?.kind as Kind;
  const targets = body?.targets as Target[];
  if (!(kind in texts) || !Array.isArray(targets)) {
    return new Response("Bad request", { status: 400 });
  }

  const serviceAccount = JSON.parse(account) as ServiceAccount;
  const accessToken = await googleAccessToken(serviceAccount);
  const results = await Promise.all(
    targets.map((target) =>
      send(serviceAccount.project_id, accessToken, target, kind)
    ),
  );
  const failed = results.filter((ok) => !ok).length;
  if (failed > 0) console.warn(`${failed} of ${targets.length} not sent`);
  return Response.json({ sent: targets.length - failed, failed });
});

async function send(
  projectId: string,
  accessToken: string,
  target: Target,
  kind: Kind,
): Promise<boolean> {
  const response = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message: {
          token: target.token,
          notification: {
            title: "ICare",
            body: texts[kind][target.language] ?? texts[kind].en,
          },
          data: { kind },
          android: { priority: "high" },
        },
      }),
    },
  );
  // A stale token (the app was removed) fails alone; the device sends a
  // fresh one the next time the app starts.
  return response.ok;
}

/// An OAuth access token for FCM, signed with the service account's key.
async function googleAccessToken(account: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const encode = (value: unknown) => base64Url(JSON.stringify(value));
  const unsigned = `${encode({ alg: "RS256", typ: "JWT" })}.${
    encode({
      iss: account.client_email,
      scope: "https://www.googleapis.com/auth/firebase.messaging",
      aud: "https://oauth2.googleapis.com/token",
      iat: now,
      exp: now + 3600,
    })
  }`;
  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToBytes(account.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(unsigned),
  );
  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: `${unsigned}.${base64Url(new Uint8Array(signature))}`,
    }),
  });
  if (!response.ok) throw new Error(`Google token: ${response.status}`);
  return (await response.json()).access_token;
}

function base64Url(value: string | Uint8Array): string {
  const bytes = typeof value === "string"
    ? new TextEncoder().encode(value)
    : value;
  return btoa(String.fromCharCode(...bytes))
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");
}

function pemToBytes(pem: string): Uint8Array {
  const base64 = pem.replace(/-----[^-]+-----/g, "").replace(/\s+/g, "");
  return Uint8Array.from(atob(base64), (char) => char.charCodeAt(0));
}

/// Compares in constant time, so the secret cannot be guessed by timing.
function sameText(a: string, b: string): boolean {
  const left = new TextEncoder().encode(a);
  const right = new TextEncoder().encode(b);
  let difference = left.length ^ right.length;
  for (let i = 0; i < Math.max(left.length, right.length); i++) {
    difference |= (left[i] ?? 0) ^ (right[i] ?? 0);
  }
  return difference === 0;
}
