#
class backup (
  $mysql      = undef,
  $postgresql = undef,
  $mongodb    = undef,
  $files      = undef,
  $ensure     = 'present'
) {
  include 'backup::config'

  $s3_access_key_id     = $backup::config::s3_access_key_id
  $s3_secret_access_key = $backup::config::s3_secret_access_key
  $s3_bucket            = $backup::config::s3_bucket
  $s3_region            = $backup::config::s3_region
  $command              = $backup::config::command
  $packages             = $backup::config::packages

  $backup_gem_ensure = $ensure ? {
    'present' => $backup::config::package_version,
    default   => 'absent'
  }

  package{ $packages:
    ensure => 'present'
  }

  package{ 'backup':
    ensure   => $backup_gem_ensure,
    provider => 'gem',
    require  => Package[$packages]
  }

  cron{ 'backup':
    ensure  => $ensure,
    command => '/etc/backup/run.sh',
    user    => 'root',
    minute  => 0,
    hour    => 4
  }

  if $ensure == 'present' {

    file {
      '/etc/backup':
        ensure  => 'directory',
        mode    => '0700';
      '/etc/backup/backup.rb':
        ensure  => 'present',
        mode    => '0600',
        content => template('backup/backup.rb.erb');
      '/etc/backup/models':
        ensure  => 'directory',
        mode    => '0700';
      '/etc/backup/run.sh':
        ensure  => 'present',
        mode    => '0700',
        content => template('backup/run.sh.erb');
    }

    if $mysql != undef {
      create_resources('backup::mysql', $mysql)
    }

    if $postgresql != undef {
      create_resources('backup::postgresql', $postgresql)
    }

    if $files != undef {
      create_resources('backup::file', $files)
    }

    if $mongodb != undef {
      create_resources('backup::mongodb', $mongodb)
    }

  }

  if $ensure == 'absent' {
    file { '/etc/backup':
      ensure => 'absent',
      force  => true
    }
  }

}
