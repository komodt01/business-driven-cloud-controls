import os
import boto3

# Allow LocalStack via AWS_ENDPOINT_URL; harmless on real AWS
s3 = boto3.client("s3", endpoint_url=os.getenv("AWS_ENDPOINT_URL"))

RISKY_URIS = {
    "http://acs.amazonaws.com/groups/global/AllUsers",
    "http://acs.amazonaws.com/groups/global/AuthenticatedUsers",
}

def handler(event, context):
    """
    Remove public ACL grants from the bucket referenced in the CloudTrail/EventBridge event.
    Expects: event["detail"]["requestParameters"]["bucketName"]
    Returns: {"remediated": <bucket>, "grants_removed": <int>}
    """
    bucket = event["detail"]["requestParameters"]["bucketName"]
    acl = s3.get_bucket_acl(Bucket=bucket)
    new_grants = [g for g in acl["Grants"] if g.get("Grantee", {}).get("URI") not in RISKY_URIS]
    s3.put_bucket_acl(
        Bucket=bucket,
        AccessControlPolicy={"Grants": new_grants, "Owner": acl["Owner"]},
    )
    return {"remediated": bucket, "grants_removed": len(acl["Grants"]) - len(new_grants)}
