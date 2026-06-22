# Bug Bounty Reversing Prompt — Critical & High Only

Use this prompt when giving me a thick client, Android APK, web app, or DMG for bug bounty analysis.

---

## Prompt to give me:

```
I am bug bounty hunting. I want you to analyze [TARGET_DMG/APK/MSI/EXE] for bug
bounty vulnerabilities. Focus ONLY on CRITICAL and HIGH severity findings.

Application context:
- Type: [thick-client | android | web-app | electron]
- Platform: [macOS | Windows | Linux | Android | iOS]
- What it does: [describe what the app does]

Requirements:
1. Extract/Decompile all code — do NOT stop at surface-level analysis
2. Map the full protocol flow / state machine — trace every input → code path
3. For each input vector (file types, URL schemes, IPC, env vars), ask:
   - Can I reach unsafe deserialization?
   - Can I poison a classpath or load order?
   - Can I bypass validation/authentication checks?
   - Can I inject into a command/process launch?
   - Can I override a trusted path with an untrusted one?
4. Report ONLY what is exploitable without physical access or exotic setup
5. Output format: table with [Vulnerability] [CWE] [Severity] [Attack Vector]
```

---

## The methodology I want you to follow

### Phase 1 — Recon & Input Surface
- Decompile ALL custom code (not just the main binary)
- List every input vector: file associations, URL schemes, IPC, argv, env vars, network
- Identify auth/security mechanisms: certificate pinning, signing, sandbox, security manager

### Phase 2 — Trace Input to Sink (the most important)
For each input vector:
- Find where the input is parsed/deserialized
- Trace it through the state machine / business logic
- Identify every validation gate (allowlist, cert check, signature check, type check)
- For EACH gate, ask: "How can I bypass this?"
- Identify the final sink (process launch, class loading, file write, network call)

### Phase 3 — Exploitability Check
- Does the attack require: network MITM? physical access? social engineering? env var setup?
- If yes to any of the above, it's still HIGH/CRITICAL (not everything requires 0-click)

### ✅ MUST CHECK (based on past mistakes)

| Check | Why it's often HIGH/CRITICAL |
|-------|-------------------------------|
| No origin/server authentication in protocol | Attacker controls responses = full chain |
| Classpath / load order poisoning | First match wins = code execution |
| "META-INF" / prefix-based validation bypasses | Classic multi-release JAR / ZIP slip |
| `SecurityManager` disabled or absent | No sandbox on subprocesses |
| TrustManager that accepts everything | Works with MITM |
| HostnameVerifier that accepts everything | Works with MITM |
| Hardcoded crypto keys (even "obfuscated") | Trivially reversible |
| Env vars checked before bundled paths | Hijack JRE or libraries |
| JSON/XML deserialization of attacker-supplied data | Deserialization RCE |
| Command-line args constructed from untrusted input | Command injection |
| File download + execute from remote | Full RCE if validation is bypassed |

### ❌ DON'T WASTE TIME ON
- XSS in a desktop app (low prio)
- CSP / cookie flags in thick client (irrelevant)
- Path traversal in a single-user app (no impact)
- Verbose logging only (no direct exploit)

### Output format

```
## [Vulnerability Title]
- **File:** path:line
- **CWE:** CWE-XXX
- **CVSS:** X.X
- **Type:** [RCE | Auth Bypass | PrivEsc | Info Leak | MITM]
- **Attack Vector:** [describe exactly what the attacker sends/does]
- **Root Cause:** [1-2 sentence code-level explanation]
- **Proof:** [key code snippet from decompiled source]
```
