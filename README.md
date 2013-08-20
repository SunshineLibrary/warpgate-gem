WarpGate
========

Ruby gem for dispatching job to Warpgate task processing service. [http://github.com/SunshineLibrary/warpgate]

```
WarpGate.setup do |config|

  config.role = 'cloud'

  config.salt = 'Sunshine Library Rocks'

  config.connection_params = {
      host: '127.0.0.1',
      port: 4023,
      vhost: '/',
      username: '',
      password: ''
  }

end
```

```
WarpGate.publish(id: 1234, action: 'nothing', role: 'local')
WarpGate.publish(id: 1234, action: 'post', role: 'local', params: { url: '...', payload: '...' })
```
