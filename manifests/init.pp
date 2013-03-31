#
class backup (
  $mysql      = undef,
  $postgresql = undef,
  $files      = undef
) {
  include 'backup::config'

  $s3_access_key_id     = $backup::config::s3_access_key_id
  $s3_secret_access_key = $backup::config::s3_secret_access_key
  $s3_bucket            = $backup::config::s3_bucket
  $s3_region            = $backup::config::s3_region
  $command              = $backup::config::command

  package{ 'backup':
    ensure   => $backup::config::package_version,
    provider => 'gem',
  }

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
    '/etc/backup/install_dependencies.sh':
      ensure  => 'present',
      mode    => '0700',
      content => template('backup/install_dependencies.sh.erb')
  }

  cron{ 'backup':
    ensure  => 'present',
    command => '/etc/backup/run.sh',
    user    => 'root',
    minute  => 0,
    hour    => 4
  }

  exec{ '/etc/backup/install_dependencies.sh':
    refreshonly => true,
    subscribe   => [Package['backup'],
                    File['/etc/backup/install_dependencies.sh']]
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
}
