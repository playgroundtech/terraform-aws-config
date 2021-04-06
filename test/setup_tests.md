## Prepare your repo to run tests

To set up terratest for your module, you first need to run the following command in this test folder:  
`go mod init github.com/playgroundcloud/name-of-your-repo`

This will create the mandatory go.mod file that defines the module’s module path and its dependency requirements, which are the other modules needed for a successful build.
The next step is to add your terraform files that you want your tests to run. This can be done in the /test/example folder.

## Set up your tests
The next step is to create test files in the test folder.  

`go test` will recompile each package along with any files with names matching the file pattern *_test.go. These *_test.go files can contain test functions, benchmark functions, and example functions. 

For some good examples of how to use terratest, follow this link: 
https://github.com/gruntwork-io/terratest/tree/master/examples

## Run your tests locally
When you have set up your tests, you can run `go test -timeout 90m` to run the whole test suit or `go test -run FunctionName -timeout 90m` to run a specific test in this folder to see if everything is correct.  
This will create a file named go.sum containing the expected cryptographic checksums of the content of specific module versions and run your tests.  
Each time a dependency is used, its checksum is added to go.sum if missing or else required to match the existing entry in go.sum.  

## Test folder overview
```
.
├── <name of your test>
│   ├── main.tf 
│   └── variables.tf
├── <name of your test>
│   ├── main.tf 
│   └── variables.tf
├── <name of your test>
│   ├── main.tf 
│   └── variables.tf
├── go.mod
├── go.sum
└── terraform_module_name_test.go
```

## Run your tests in Github Actions
Finally, you can uncomment the .github/workflows/terrafest.yml file for your tests to be run with Github Actions when you open a PR to master. If you would like to run your tests on another branch, you can comment out the 
```
on:
  pull_request:
  branches:
    - master
  paths-ignore:
    - '**.md'
```

in the terratest.yml file and replace it with the following: 

```
on:
  push:
    branches-ignore:
      - master
    paths-ignore:
      - '**.md'
```

After you have set up your tests, you can delete this file from your repo. 