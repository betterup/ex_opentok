import Config

config :ex_opentok,
  iss: "project",
  key: System.get_env("OPENTOKSDK_KEY"),
  secret: System.get_env("OPENTOKSDK_SECRET"),
  ttl: 300
