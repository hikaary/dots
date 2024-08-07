import json
import base64
import urllib.parse
import sys

def vless_to_config(vless_url):
    # Remove the "vless://" prefix
    vless_url = vless_url.replace("vless://", "")

    # Split the URL into its components
    user_info, server_info = vless_url.split("@")

    # Extract user ID
    user_id = user_info

    # Extract host, port, and parameters
    host_port, params = server_info.split("?")
    host, port = host_port.split(":")

    # Parse parameters
    params_dict = dict(urllib.parse.parse_qsl(params))

    # Create the outbound configuration
    outbound = {
        "protocol": "vless",
        "settings": {
            "vnext": [{
                "address": host,
                "port": int(port),
                "users": [{
                    "id": user_id,
                    "encryption": "none"
                }]
            }]
        },
        "streamSettings": {
            "network": params_dict.get("type", "tcp"),
            "security": params_dict.get("security", "none")
        }
    }

    # Add TLS settings if security is tls
    if outbound["streamSettings"]["security"] == "tls":
        outbound["streamSettings"]["tlsSettings"] = {
            "serverName": params_dict.get("sni", host)
        }

    # Create the full configuration
    config = {
        "inbounds": [{
            "port": 1080,
            "protocol": "socks",
            "settings": {
                "auth": "noauth",
                "udp": True
            }
        }],
        "outbounds": [outbound]
    }

    return json.dumps(config, indent=2)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python script.py <vless_url>")
        sys.exit(1)

    vless_url = sys.argv[1]
    config = vless_to_config(vless_url)
    print(config)
