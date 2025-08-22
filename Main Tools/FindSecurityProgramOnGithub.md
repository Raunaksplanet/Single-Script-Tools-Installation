Use GitHub’s regex form with slashes:

**Single label + TLD (e.g., `security@acme.io`):**

```
/\bsecurity@[A-Za-z0-9-]+\.[A-Za-z]{2,}\b/
```

**Allow multi-label domains (e.g., `security@acme.co.uk`):**

```
/\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/
```

**If you also want to allow underscores in the label (looser):**

```
/\bsecurity@(?:[A-Za-z0-9_-]+\.)+[A-Za-z]{2,}\b/
```

Examples you can paste in GitHub search:

```
filename:SECURITY /\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/ -security@example.com
language:Markdown /\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/ -example.com
```

Perfect — here are some **ready-to-use GitHub dorks** to discover bug bounty contact emails (`security@<company>.tld`):

---

### 🎯 Core dork (finds real contacts, skips placeholders)

```
/\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/ -security@example.com -example.org
```

---

### 🔎 Target common policy files

```
filename:SECURITY /\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/
filename:HACKING /\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/
path:.github /\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/
```

---

### 📚 Inside documentation

```
(extension:md OR extension:txt OR extension:rst) /\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/ -example.com
```

---

### 🏢 Org-scoped (replace `ORG` with target org)

```
org:ORG /\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/
```

---

### 📝 README + policy mentions

```
(filename:README OR filename:SECURITY OR filename:SECURITY.md OR filename:VULNERABILITY.md) /\bsecurity@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b/
```

---

Want me to also add a **combined “master dork”** that pulls across *all these patterns* in one query (so you just paste once and run)?
