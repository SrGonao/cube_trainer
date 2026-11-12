# Slotwise

CFOP and Roux trainer for GAN smart cubes. One web app for laptop and Android, with sync.

## Files

- `index.html` – the whole app
- `config.js` – your Supabase project URL and key (fill in once)
- `manifest.webmanifest`, `sw.js`, `icon-*.png` – make it installable and usable offline
- `supabase-setup.sql` – creates the two sync tables

## Setup (about 15 minutes, on the laptop)

### 1. Supabase (sync)

1. Create a free account at supabase.com and a new project.
2. Open **SQL Editor**, paste the contents of `supabase-setup.sql`, press **Run**.
3. Open **Authentication → Users → Add user → Create new user**. Enter your email and a password and tick **Auto Confirm User**.
4. Open the project's API settings (Project Settings → API Keys / Data API). Copy the **Project URL** and the **publishable** key (older projects call it the **anon** key). Never use the secret / service_role key.
5. Put both into `config.js`.

### 2. GitHub Pages (hosting)

1. Create a new **public** repository on github.com, for example `slotwise`.
2. **Add file → Upload files**, drag in everything from this folder, commit.
3. **Settings → Pages → Build and deployment**: Source "Deploy from a branch", branch `main`, folder `/ (root)`, Save.
4. After a minute the app is at `https://<your-user>.github.io/slotwise/`.

The repository is public, so the code and `config.js` are visible. That is fine: the key in
`config.js` is meant to be public, and the database only lets a signed-in user touch their own rows.

### 3. Each device

1. **Laptop:** open the address in Chrome. Bring your existing data over first: in the old
   localhost copy press **Export backup**, then in the new one **Import backup**. Then sign in under
   **Your data → Sync between devices**. Install with the icon in the address bar if you like.
2. **Phone:** open the same address in Chrome on Android, sign in, then menu → **Add to Home screen → Install**.

Bluetooth on Android: Chrome needs the Nearby devices (and on older Android, Location) permission.
The cube's MAC address syncs from the laptop, so the phone should not need to ask for it.

## How sync behaves

- Everything is saved on the device first; sync runs a few seconds after a change, when the app
  opens, and when it comes back into view.
- Solves and log entries sync one by one, so two devices never overwrite each other's solves.
  Deleting a solve deletes it everywhere.
- Cards merge per card (the more recently practised side wins). For settings, the device you are on wins.
- When another device has new data: right after opening, the app loads it and restarts by itself.
  Later, or with a cube connected, it shows **Load it** under Your data instead, because
  restarting drops the cube connection.

## Updating the app

Upload the new `index.html` to the repository. Devices pick it up the next time they open online.
