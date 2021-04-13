package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAwsExampleMinimal(t *testing.T) {
	t.Parallel()

	s3BucketName := fmt.Sprintf("terratest-aws-config-example-%s", random.UniqueId())
	s3BucketNameLower := strings.ToLower(s3BucketName)
	awsRegion := "eu-north-1"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "./example_minimal",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"s3_bucket_name": s3BucketNameLower,
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
