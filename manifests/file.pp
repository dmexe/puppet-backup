#
define backup::file(
  $path,
  $user   = $name,
  $ensure = 'present'
) {

  $backup_name = "${name}_files"

  file{ "/etc/backup/models/${backup_name}.rb":
    ensure  => $ensure,
    content => template('backup/file.rb.erb')
  }
}
