Github Dorking
/[A-Za-z0–9-_]+\.example\.com\/+/ AND (apikey OR api_key OR secret OR password OR credentials OR token OR bearer OR authorization OR client_secret OR client_id OR access_token OR private_key OR ssh-rsa OR ssh-dss OR -----BEGIN OR -----END OR .env OR config OR aws_access_key_id OR aws_secret_access_key OR db_password OR ftp_password OR smtp_password OR auth_token OR bearer_token OR oauth_token OR jwt OR session_token OR s3.amazonaws.com OR s3:// OR .s3.amazonaws.com OR s3-external- OR s3.dualstack. OR s3-website- OR s3.ap OR s3.us OR s3.eu OR s3.ca OR s3.sa)

# second level domain
/[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.example\.com\//

# third level domain
/[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.example\.com\//
