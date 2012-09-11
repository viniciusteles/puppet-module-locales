class locales(
  $locale='en_US.UTF-8', 
  $language='en_US:en',
  $available=['en_US.UTF-8 UTF-8']
) {
  package { 'locales':
    ensure => present,
  }

  file { '/etc/locale.gen':
    content => inline_template('<%= available.join("\n") + "\n" %>'),
  }

  file { '/etc/default/locale':
    content => inline_template(join([
      'LANG=<%= locale %>',
      'LANGUAGE=<%= language %>'
    ], "\n")),
  }

  exec { '/usr/sbin/locale-gen':
    subscribe   => [File['/etc/locale.gen'], File['/etc/default/locale']],
    refreshonly => true,
  }

  exec { '/usr/sbin/update-locale':
    subscribe   => [File['/etc/locale.gen'], File['/etc/default/locale']],
    refreshonly => true,
  }

  Package[locales] -> File['/etc/locale.gen'] -> File['/etc/default/locale']
  -> Exec['/usr/sbin/locale-gen'] -> Exec['/usr/sbin/update-locale']
}
