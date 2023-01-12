# S3 triggers Lambda module

Simple module that configures a bucket to trigger a lambda function. Creates the lambda from a source directory with the appropiate permissions to launch from S3.

Whilst this has been built for internal use it is publily available. 

## Lambdas
Only zip lambdas are supported, layers are supported. 

## Zip/Version Management
It will automatically create a new zip file when the random_keeper_id is changed. This can be set via a filemd5 has function to automatically update. See example for how to create an md5 based on files.


## Examples
See the examples folder.


<!-- BEGIN_TF_DOCS -->


<!-- END_TF_DOCS -->