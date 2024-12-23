import jwt

# Original JWT token and secret
original_jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
secret = "your-256-bit-secret"

# Decode the JWT (without verifying the signature)
decoded = jwt.decode(original_jwt, secret, algorithms=["HS256"], options={"verify_signature": False})

# Modify the payload (e.g., changing the name)
decoded["name"] = "Jane Doe"

# Encode the modified payload back into a JWT with the original secret
new_jwt = jwt.encode(decoded, secret, algorithm="HS256")

print(f"Original JWT: {original_jwt}")
print(f"Modified JWT: {new_jwt}")
