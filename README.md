# Cloudflare Blocklist

A script with a Github action to automatically create and update a ads blocklist policy for Cloudflare Zero Trust Gateway.

The script works by downloading the OISD small blocklist everyday, splitting it into smaller chunks, uploading it to Cloudflare as multiple lists of domains, and then creating a policy that blocks all traffic to the domains in the lists.

This project is based off Jacob Gelling's [Cloudflare Gateway Block Ads](https://github.com/jacobgelling/cloudflare-gateway-block-ads). We assume that OISD blocklist always updates everyday anyways and we do not unnecessarily make new commits that spam the repository commit history.

## Setup

Follow the original repository as the setup is the same. You can refer to the `.env.example` to create a local `.env` to run these scripts locally.
