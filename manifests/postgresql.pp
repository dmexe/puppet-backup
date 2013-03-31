#
define backup::postgresql(
  $database,
  $password,
  $user   = $name,
  $host   = 'localhost',
  $port   = '5432',
  $ensure = 'present'
) {

  $backup_name = "${name}_postgresql"

  file{ "/etc/backup/models/${backup_name}.rb":
    ensure  => $ensure,
    content => template('backup/postgresql.rb.erb')
  }
}
