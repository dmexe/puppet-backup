#
define backup::mongodb(
  $database,
  $password,
  $user   = $name,
  $host   = 'localhost',
  $port   = '27017',
  $ensure = 'present'
) {

  $backup_name = "${name}_mongodb"

  file{ "/etc/backup/models/${backup_name}.rb":
    ensure  => $ensure,
    content => template('backup/mongodb.rb.erb')
  }
}
