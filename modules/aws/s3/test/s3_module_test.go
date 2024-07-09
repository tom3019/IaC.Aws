package s3_test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestS3Example(t *testing.T) {

	ops := &terraform.Options{
		TerraformDir: "../example",
	}

	defer terraform.Destroy(t, ops)

	terraform.InitAndApply(t, ops)

	bucketArn := terraform.Output(t, ops, "bucket_arn")
	bucketTags := terraform.OutputMap(t, ops, "tags")
	assert.NotNil(t, bucketArn)
	assert.Equal(t, "evertrust-s3-bucket-module-example", bucketTags["Name"])
}
