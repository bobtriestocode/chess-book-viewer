@echo off
setlocal

set BUCKET_NAME=<YOUR_BUCKET_NAME>
set DISTRIBUTION_ID=<YOUR_DISTRIBUTION_ID>

echo Uploading index.html to s3://%BUCKET_NAME%/ ...
aws s3 cp index.html s3://%BUCKET_NAME%/index.html --content-type "text/html"
if errorlevel 1 goto :error

echo Invalidating CloudFront cache for distribution %DISTRIBUTION_ID% ...
aws cloudfront create-invalidation --distribution-id %DISTRIBUTION_ID% --paths "/*"
if errorlevel 1 goto :error

echo Done.
goto :eof

:error
echo Deployment failed.
exit /b 1
