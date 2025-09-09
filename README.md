# Cloudflare Blocklist

A script + GitHub Action that automatically creates and updates an ads domain blocklist for Cloudflare Zero Trust Gateway.

The script works by downloading the [OISD small blocklist](https://oisd.nl) everyday, splitting it into smaller chunks, uploading it to Cloudflare as multiple lists of domains, and then creating a policy that blocks all traffic to the domains in the lists.

This project is based off Jacob Gelling's [Cloudflare Gateway Block Ads](https://github.com/jacobgelling/cloudflare-gateway-block-ads). The difference with the original project is that we always update the blocklist without any difference check. We instead let the Github action run the script everyday. This avoids unnecessary commits that spam the repository commit history that could occur every hour.

## Setup

1. Fork this repository

2. Environment Variables

   - Set ACCOUNT_ID and API_TOKEN in your Github Actions Repository Secrets
   - Find ACCOUNT_ID by going to Cloudflare -> Account Home. Copy the id from the URL param: `https://dash.cloudflare.com/account_id/home`
   - Create the API_TOKEN by going to https://dash.cloudflare.com/profile/api-tokens and create a token with `Edit` permissions on `Account.Zero Trust`
   - \*\* Refer to the `.env.example` to create a local `.env` to run these scripts locally

## Notes

- [Cloudflare Zero Trust free tier limits](https://developers.cloudflare.com/cloudflare-one/account-limits/) as of writing:
  | Feature | Limit |
  |---|---|
  | User lists | 100 |
  | Entries per list | 1,000 |
  | Total domains (100 × 1,000) | 100,000 |

  OISD small blocklist size: ~45,600 domains.

  The free tier can accommodate OISD small (~45.6k) across multiple lists.

- There is no GitHub Action to delete the lists and policy. To remove lists locally, set the environment variables in `.env` and run:
  ```bash
  ./delete_blocklist.sh
  ```
