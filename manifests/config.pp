#
class backup::config (
  $package_version      = '3.7.1',
  $s3_access_key_id     = undef,
  $s3_secret_access_key = undef,
  $s3_bucket_default    = undef,
  $s3_region            = 'eu-west-1',
  $local                = undef,
  $command              = '/usr/local/bin/backup'
) {
  $s3_bucket = $s3_bucket_default ? {
    undef   => "master.${::environment}",
    default => $s3_bucket_default
  }

  $packages = $::osfamily ? {
    'Debian' => ['rubygems', 'libxml2-dev', 'libxslt1-dev'],
    default  => undef
  }
}
