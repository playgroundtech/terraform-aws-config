// NO tests in this testsuite can be runned in Parallel due 'aws_config' and the maximum number of configuration recorders: 1.
// Therefore there is no t.Parallel() function in this test-suite.
package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"strings"
	"testing"
)

func TestConfigExampleMinimal(t *testing.T) {
	s3BucketName := fmt.Sprintf("terratest-aws-config-example-%s", random.UniqueId())
	s3BucketNameLower := strings.ToLower(s3BucketName)
	awsRegion := "eu-north-1"
	workingDir := "./example_minimal"

	defer test_structure.RunTestStage(t, "destroy", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
		terraform.Destroy(t, terraformOptions)
		// clean up saved options
		test_structure.CleanupTestDataFolder(t, workingDir)
	})

	test_structure.RunTestStage(t, "init", func() {
		terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
			// The path to where our Terraform code is located
			TerraformDir: workingDir,

			// Variables to pass to our Terraform code using -var options
			Vars: map[string]interface{}{
				"s3_bucket_name": s3BucketNameLower,
			},

			// Environment variables to set when running Terraform
			EnvVars: map[string]string{
				"AWS_DEFAULT_REGION": awsRegion,
			},
		})
		test_structure.SaveTerraformOptions(t, workingDir, terraformOptions)
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t,"tests", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
		bucketID := terraform.Output(t, terraformOptions, "aws_logs_bucket_id")
		// Verify that our Bucket exists
		aws.AssertS3BucketExists(t, awsRegion, bucketID)

		// Verify that our Bucket has versioning enabled
		actualStatus := aws.GetS3BucketVersioning(t, awsRegion, bucketID)
		expectedStatus := "Enabled"
		assert.Equal(t, expectedStatus, actualStatus)

		terraform.ApplyAndIdempotent(t, terraformOptions)
	})
}


func TestConfigNoBucket(t *testing.T) {
	s3BucketName := fmt.Sprintf("terratest-aws-config-example-%s", random.UniqueId())
	s3BucketNameLower := strings.ToLower(s3BucketName)
	configName := fmt.Sprintf("terratest-config-%s", random.UniqueId())
	configRoleName := fmt.Sprintf("terratest-config-role-%s", random.UniqueId())
	configIAMPolicyName := fmt.Sprintf("terratest-config-role-policy-%s", random.UniqueId())
	awsRegion := "eu-north-1"
	workingDir := "./example_no_bucket"

	defer test_structure.RunTestStage(t, "destroy", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
		terraform.Destroy(t, terraformOptions)
		// clean up saved options
		test_structure.CleanupTestDataFolder(t, workingDir)
	})

	test_structure.RunTestStage(t, "init", func() {
		terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
			// The path to where our Terraform code is located
			TerraformDir: workingDir,

			// Variables to pass to our Terraform code using -var options
			Vars: map[string]interface{}{
				"s3_bucket_name": s3BucketNameLower,
				"config_name": configName,
				"config_role_name": configRoleName,
				"config_iam_policy_name": configIAMPolicyName,
			},

			// Environment variables to set when running Terraform
			EnvVars: map[string]string{
				"AWS_DEFAULT_REGION": awsRegion,
			},
		})
		test_structure.SaveTerraformOptions(t, workingDir, terraformOptions)
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t,"tests", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
		bucketID := terraform.Output(t, terraformOptions, "aws_logs_bucket_id")
		// Verify that our Bucket exists
		aws.AssertS3BucketExists(t, awsRegion, bucketID)

		// Verify that our Bucket has versioning enabled
		actualStatus := aws.GetS3BucketVersioning(t, awsRegion, bucketID)
		expectedStatus := "Enabled"
		assert.Equal(t, expectedStatus, actualStatus)

		terraform.ApplyAndIdempotent(t, terraformOptions)
	})
}
