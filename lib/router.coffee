Router.configure({
  layoutTemplate: 'layout'
})
Router.map ()->
  this.route('index', {path: '/'})
  this.route('digitalOceanLogin', {path: 'https://cloud.digitalocean.com/v1/oauth/authorize?client_id=ba7690c54b256ff7482d2de387f7737d02a3e59f8516f1c2faf228b7269339a2&redirect_uri=http%3A%2F%2F127.0.0.1%3A3000%2Fdigitalocean%2Foauthcallback&response_type=code&scope=read write'})
  this.route('digitalOcean',
    where: 'server'
    path: '/digitalocean/oauthcallback'
    action: ()->
      res = this.response
      HTTP.call('POST', 'https://cloud.digitalocean.com/v1/oauth/token',
        data:
          grant_type: 'authorization_code'
          code: this.params.query.code
          client_id: 'ba7690c54b256ff7482d2de387f7737d02a3e59f8516f1c2faf228b7269339a2'
          client_secret: '172e022689a4b85608be0442d14604cc1af6488de4572c22e2735b41ea0e6dc8'
          redirect_uri: 'http://127.0.0.1:3000/digitalocean/oauthcallback'
        (error,result)->
          if !error
            alreadyExist = Accounts.findOne({uid: result.data.uid})
            userInfo = result.data.info
            userInfo.uid = result.data.uid
            if not alreadyExist
              Accounts.insert(userInfo)
            res.writeHead(301, {Location: '/'})
            res.end()
      )
  )



