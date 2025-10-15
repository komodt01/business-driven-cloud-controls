import boto3
from moto import mock_aws
from functions.s3_public_acl_remediator import handler

@mock_aws
def test_removes_public_grants():
    s3 = boto3.client("s3", region_name="us-east-1")
    s3.create_bucket(Bucket="demo")
    # Make the bucket risky
    s3.put_bucket_acl(Bucket="demo", ACL="public-read")

    event = {"detail": {"requestParameters": {"bucketName": "demo"}}}
    out = handler(event, None)
    assert out["remediated"] == "demo"

    acl = s3.get_bucket_acl(Bucket="demo")
    risky = [
        g for g in acl["Grants"]
        if g["Grantee"].get("URI") in (
            "http://acs.amazonaws.com/groups/global/AllUsers",
            "http://acs.amazonaws.com/groups/global/AuthenticatedUsers",
        )
    ]
    assert risky == []
