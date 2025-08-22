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
