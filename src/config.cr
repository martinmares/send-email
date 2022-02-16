require "yaml"

module SendEmail
  class Config
    include YAML::Serializable

    @[YAML::Field(key: "smtp")]
    property smtp : Smtp

    @[YAML::Field(key: "mail")]
    property mail : Mail

    def self.load(from = file)
      content = File.read(from)
      self.from_yaml(content)
    end
  end

  class Smtp
    include YAML::Serializable

    @[YAML::Field(key: "hostname")]
    property hostname : String

    @[YAML::Field(key: "port")]
    property port : Int32
  end

  class Mail
    include YAML::Serializable

    @[YAML::Field(key: "subject")]
    property subject : String

    @[YAML::Field(key: "from")]
    property from : Email

    @[YAML::Field(key: "to")]
    property to : Array(Email)

    @[YAML::Field(key: "cc", emit_null: true)]
    property cc : Array(Email)?

    @[YAML::Field(key: "bcc", emit_null: true)]
    property bcc : Array(Email)?

    @[YAML::Field(key: "templates")]
    property templates : Templates
  end

  class Email
    include YAML::Serializable

    @[YAML::Field(key: "address")]
    property address : String

    @[YAML::Field(key: "name", emit_null: true)]
    property name : String?
  end

  class Templates
    include YAML::Serializable

    @[YAML::Field(key: "body")]
    property body : Body
  end

  class Body
    include YAML::Serializable

    @[YAML::Field(key: "text")]
    property text : String

    @[YAML::Field(key: "html", emit_null: true)]
    property html : String?
  end
end
