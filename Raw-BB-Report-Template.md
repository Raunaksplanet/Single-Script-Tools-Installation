Write a bug bounty report in this format. Do not add theoretical scenarios. Do not mention DoS or DDoS. Add severity accordingly. Provide relevant CWE ID or other applicable classification. Also, include the complete CVSS v3.1 vector with each metric explained under a separate heading.

Bug Report: Active Web Session Persists After Account Deactivation
Severity: High
Bug Type: Session Management / Authentication Flaw
CWE ID: CWE-613 – Insufficient Session Expiration


Introduction:
I discovered a session management flaw where the platform fails to invalidate active web sessions when a user deactivates their account from the mobile app. As a result, an attacker with access to an active session can continue using the account even after deactivation, leading to unauthorized access.

Steps to Reproduce:
1. Log in to the same account on both the mobile app and web application.
2. From the mobile app, navigate to account settings and deactivate the account.
3. On the web application, refresh the page.
4. Observe that the session remains active, and actions can still be performed.

Impact:
1. Unauthorized Access: Continued access to the account after deactivation.
2. Account Takeover Risk: Attackers with an active session retain control.
3. Privacy Violation: Users expect all sessions to terminate upon deactivation.

CVSS v3.1 Score:
Base Score: 7.5 (High)
Vector String: `CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:N`

CVSS Metric Breakdown:
* AV\:N (Attack Vector – Network): Exploitable remotely via browser.
* AC\:L (Attack Complexity – Low): No special conditions needed.
* PR\:L (Privileges Required – Low): Attacker needs valid session.
* UI\:N (User Interaction – None): No user interaction needed.
* S\:U (Scope – Unchanged): No cross-boundary impact.
* C\:H (Confidentiality Impact – High): Attacker accesses sensitive data.
* I\:H (Integrity Impact – High): Attacker performs unauthorized actions.
* A\:N (Availability Impact – None): No disruption to service.

Suggested Fix:
1. Revoke all active sessions upon account deactivation.
2. Ensure session tokens expire immediately after deactivation.
3. Implement real-time session validation on each request.
4. Provide users with the option to view and log out from all active sessions.

Proof of Concept: <Video Link>

Reference:
https://hackerone.com/reports/1285538

Conclusion:
Failure to invalidate active sessions after account deactivation is a critical session management issue. Enforcing proper session termination is essential to protect user security and privacy.
