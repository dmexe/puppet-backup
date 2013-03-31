#
define backup::mysql(
  $database,
  $password,
  $user   = $name,
  $host   = 'localhost',
  $port   = '3306',
  $ensure = 'present'
) {

  $backup_name = "${name}_mysql"

  file{ "/etc/backup/models/${backup_name}.rb":
    ensure  => $ensure,
    content => template('backup/mysql.rb.erb')
  }
}
