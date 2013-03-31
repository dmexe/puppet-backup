#
class backup::config (
  $package_version      = '3.1.3',
  $s3_access_key_id     = undef,
  $s3_secret_access_key = undef,
  $s3_backet_default    = undef,
  $s3_region            = 'eu-west-1',
  $command              = '/usr/local/bin/backup'
) {
  $s3_bucket = $s3_bucket_default ? {
    undef   => "master.${::environment}",
    default => $s3_bucket_default
  }
}
