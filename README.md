# Cloudflare Blocklist for Ads

A script + GitHub Action that automatically creates and updates an ads domain blocklist for Cloudflare Zero Trust Gateway.

The script works by:

1. Downloading the [OISD small blocklist](https://oisd.nl) everyday
2. Splitting it into smaller chunks
3. Creating and updating Cloudflare Zero Trust User Lists from each chunk
4. Then creating a policy that blocks all traffic to the domains in the lists

This project is based off Jacob Gelling's [Cloudflare Gateway Block Ads](https://github.com/jacobgelling/cloudflare-gateway-block-ads). The difference between this project and the original project is that the script always updates the blocklist without any diff check. We instead let the Github action run the script everyday, which avoids unnecessary commits that spam the repository commit history that could occur every hour.

## Setup

1. Fork this repository

2. Environment Variables

   - Set ACCOUNT_ID and API_TOKEN in your Github Actions Repository Secrets
   - Find ACCOUNT_ID by going to Cloudflare -> Account Home. Copy the id from the URL param: `https://dash.cloudflare.com/account_id/home`
   - Create the API_TOKEN by going to https://dash.cloudflare.com/profile/api-tokens and create a token with `Edit` permissions on `Account.Zero Trust`
   - \*\* Refer to the `.env.example` to create a local `.env` to run these scripts locally

## Notes

- By default, Cloudflare Zero Trust **logs** all DNS requests, so DNS activity can be **traced**. To improve privacy, disable Gateway DNS "Activity logging" at Cloudflare Zero Trust -> Settings -> Network. You can also disable "Activity Logging" entirely, if you do not need logs from the other categories.

- [Cloudflare Zero Trust free tier limits](https://developers.cloudflare.com/cloudflare-one/account-limits/) as of writing:
  | Feature | Limit |
  |---|---|
  | User lists | 100 |
  | Entries per list | 1,000 |
  | Total domains (100 × 1,000) | 100,000 |

  > OISD small blocklist size: ~45,600 domains.

  The free tier can accommodate OISD small (~45.6k) across multiple lists.

- We are using `https://small.oisd.nl/domainswild2` as Cloudflare Zero Trust User List do not support wildcards (*).

- There is no GitHub Action to delete the lists and policy. To remove lists locally, set the environment variables in `.env` and run:

  ```bash
  ./delete_blocklist.sh
  ```
