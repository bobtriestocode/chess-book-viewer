# Improvements

## Done

- [x] Load a PGN file to pre-populate the board with a game
- [x] PGN textarea — paste raw PGN directly without a file
- [x] Keyboard shortcuts — arrow keys for next/previous move
- [x] Copy FEN / Copy PGN buttons — one-click to copy the current position's FEN or the full move list as PGN to clipboard
- [x] Live FEN update — keep the FEN field in sync with the board while the FEN panel is open (when the field is not focused)
- [x] Notes panel — type annotations tied to a position; embedded as PGN comments when you Copy PGN

## Not needed

- Remember last divider position across sessions (localStorage)
- Bookmark current page + board position to resume later

## To do

- [ ] Variation / branch support — tree structure for side lines so you can branch off, go back, and explore alternatives (like Lichess analysis)
- [ ] Multi-game PGN: dropdown to pick a game/chapter when a PGN file contains multiple games
- [ ] DjVu file support (via DjVu.js library)

## Deployment

`deploy.bat` (in the project root) uploads `index.html` to S3 and invalidates the CloudFront cache.

Prerequisites:
- Install AWS CLI (`winget install Amazon.AWSCLI`)
- Run `aws configure` once to set up credentials
- Edit `deploy.bat` and replace `<YOUR_BUCKET_NAME>` and `<YOUR_DISTRIBUTION_ID>` with your actual values

Finding your bucket name:
- AWS Console → S3 → the bucket list shows the name directly
- Or via CLI: `aws s3 ls`

Finding your distribution ID:
- AWS Console → CloudFront → Distributions → the `Id` column
- Or via CLI: `aws cloudfront list-distributions --query "DistributionList.Items[].{Id:Id,Domain:DomainName}" --output table`

## Custom domain (once purchased)

1. **Request a certificate** — AWS Console → Certificate Manager (ACM), region **must be US East (N. Virginia)** for CloudFront. "Request certificate" → enter your domain (e.g. `chess.example.com`) → DNS validation.
2. **Validate it** — ACM shows a CNAME record to add. Add that record at your domain registrar's DNS settings (or Route 53 if that's where the domain lives). Wait for status to become "Issued" (usually a few minutes).
3. **Attach domain to CloudFront** — Console → CloudFront → your distribution → Edit → "Alternate domain name (CNAME)" → add your domain → "Custom SSL certificate" → select the ACM certificate from step 1 → Save.
4. **Point DNS to CloudFront** — at your registrar (or Route 53), add a record for your domain pointing to the distribution's `.cloudfront.net` address:
   - Route 53: create an **A record** with "Alias" toggled on, targeting the CloudFront distribution directly.
   - Any other registrar: create a **CNAME record** (subdomains only, e.g. `chess.example.com`) pointing to the distribution's domain name shown in the CloudFront console.
5. **Wait & verify** — DNS propagation can take a few minutes to a few hours. Visit your domain once it resolves.

Note: bare/apex domains (e.g. `example.com` with no subdomain) need Route 53 (or a registrar supporting ALIAS/ANAME records) since plain CNAME isn't allowed at the root.
