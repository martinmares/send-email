# send-email

A simple utility to send an email (`send-email`) with attachment(s). For example for use in gitlab pipeline.

# TL;DR

1. create directories:

```bash
mkdir conf/
mkdir template/
```

2. create template file `templates/body.txt`

```txt
Hello world!
```

3. create template file `templates/body.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hello world!</title>
</head>
<body>
  <b>Hello world!</b>
</body>
</html>
```

4. create configuration file `conf/mail.yml`

```yml
smtp:
  hostname: smtp-relay.example.com
  helo_domain: example.com
  port: 2525
mail:
  subject: Hello world!
  from:
    address: noreply@example.com
    name: Noreply
  to:
  - address: real-user-name@example.com
    name: User Name
  templates:
    body:
      text: templates/hello-body.txt
      html: templates/hello-body.html
```

5. send email!


```bash
$ ./bin/send-email --config conf/hello-world.yml

2022/06/22 17:19:27 [e_mail.client/43983] Info [EMail_Client] Start TCP session to smtp-relay.example.com:2525
2022/06/22 17:19:27 [e_mail.client/43983] Info [EMail_Client] Successfully sent a message from <noreply@example.com> to 1 recipient(s)
2022/06/22 17:19:27 [e_mail.client/43983] Info [EMail_Client] Close session to smtp-relay.example.com:2525
```

6. or send email with attachment!

```bash
./bin/send-email --config conf/hello-world.yml -a README.md
```

7. or add more attachments!

```bash
./bin/send-email --config conf/hello-world.yml -a README.md -a LICENSE
```

## Installation

```bash
shards build --production
cp ./bin/send-email /usr/local/bin/
```

## Usage

```bash
$ ./bin/send-email --help
Usage: send-email [arguments]
    -c CONFIG, --config=CONFIG       Specifies the name of the configuration file
    -a ATTACHMENT, --attachment=ATTACHMENT
                                     Attachment file to email (can be set multiple times)
    -h, --help                       Show this help
```
## Development

```bash
$ sentry -b "crystal build ./src/send-email.cr -o ./bin/send-email" \
       -r "./bin/send-email" \
       --run-args "-c conf/dev.yml"
```


```bash
$ cat conf/dev.yml

smtp:
  hostname: localhost
  helo_domain: localhost
  port: 2525
mail:
  subject: Hello world!
  from:
    address: noreply@example.com
    name: Noreply
  to:
  - address: real-user-email@example.com
    name: User Name
```

## Contributing

1. Fork it (<https://github.com/your-github-user/send-email/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Martin Mareš](https://github.com/your-github-user) - creator and maintainer
